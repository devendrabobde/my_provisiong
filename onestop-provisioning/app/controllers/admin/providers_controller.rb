class Admin::ProvidersController < ApplicationController
  require 'csv'
  include ProvisioningOis
  include ProvisioingCsvValidation

  before_filter :find_cao
  before_filter :require_coa_login
  before_filter :find_application, :only => [:upload]

  # Return list of uploaded files.
  def application
    @registered_applications = RegisteredApp.all
    if params[:registered_app_id].present?
      @audit_trails = @cao.organization.audit_trails.where("fk_registered_app_id =?", params[:registered_app_id]).order(:createddate) rescue []
    else
      if @registered_applications.first.present?
        @audit_trails = @cao.organization.audit_trails.where(fk_registered_app_id: @registered_applications.first.id).order(:createddate) rescue []
      end
    end
    respond_to do |format|
      format.html
      format.js {
        result = render_to_string(partial: "/admin/providers/audit_trail_list", locals: { audit_trails: @audit_trails })
        render json: { html: result }
      }
    end
  end

  # get details of a uploaded providers
  def show
    provider_app_detail_ids = @cao.organization.provider_app_details.where(fk_audit_trail_id: params[:id])
    @providers = Provider.where("fk_provider_app_detail_id in (?)", provider_app_detail_ids)
    @audit_trail = AuditTrail.find(params[:id])
    @upload_error = ProviderErrorLog.where(fk_audit_trail_id: @audit_trail.id).first
  end

  # Download csv of providers uploaded previously
  def download
    if params[:audit_id].present?
      provider_app_detail_ids = @cao.organization.provider_app_details.where(fk_audit_trail_id: params[:audit_id] )
      @providers = Provider.where("fk_provider_app_detail_id in (?)", provider_app_detail_ids)
      reg_app = AuditTrail.find(params[:audit_id]).registered_app
    else
      provider_app_detail_ids = @cao.organization.provider_app_details.where(fk_registered_app_id: params[:id] )
      @providers = Provider.where("fk_provider_app_detail_id in (?)", provider_app_detail_ids).limit(5)
      reg_app = RegisteredApp.find(params[:id])
    end
    respond_to do |format|
      format.html
      format.csv { send_data @providers.to_csv(reg_app, {}), :type => 'text/csv; charset=utf-8; header=present',
                   :disposition => "attachment; filename= #{reg_app.app_name}_Providers_#{DateTime.now.to_s}.csv" }
    end
  end

  # Upload and process providers csv file
  def upload
    begin
      error_message, success_message, invalid_providers = "", "", []
      file_path, file_name = store_csv
      providers, upload_file_status = ProvisioingCsvValidation::process_csv(file_path, @application)
      if upload_file_status
        providers = providers.collect { |x| x if x.present? }.compact
        if providers.present?
          duplicate_record_status, duplicate_npis, providers = check_provider_duplicate_records(providers)
          if duplicate_record_status
            required_field_status, required_field_errors, invalid_providers = ProvisioingCsvValidation::validate_required_field(providers, @application)
            if required_field_status
              @audit_trail = save_audit_trails(file_name)
              save_providers(providers)
              success_message = "Thanks for uploading providers, we are processing uploaded file."
              success_message = duplicate_npis.count > 0 ? success_message + " As NPI #{duplicate_npis.join(",")} record is duplicated in the uploaded CSV file. In this case we are simply passing unique record for each." : success_message
            else
              error_message = "Providers required fields can't be blank, please correct " + required_field_errors.join(", ") + " fields before proceeding " + invalid_providers.join(", ")
            end
          else
            error_message = "For EPCS, the NPI must be unique for each record in the file. Please remove duplicate NPI #{duplicate_npis.join(",")} record from CSV file before proceeding."
          end
        else
          error_message = "Please check uploaded csv file. A csv file from another application should not be uploaded into any other application."
        end
      else
        error_message = "Uploaded providers csv file is empty."
      end
      if error_message.present?
        flash[:error] = error_message
        AuditTrailsLog.error error_message 
      else
        flash[:notice] = success_message
        AuditTrailsLog.warn success_message 
      end
    rescue => e
      puts e.inspect
      err = (e.class.to_s == "CSV::MalformedCSVError") ? "Error IN CSV File: " : "Error: "
      flash[:error] = err + e.message
    end
    redirect_to application_admin_providers_path
  end
  
  # Pull audit trail record to verify file upload status
  def pull_redis_job_status
    audit_trail = AuditTrail.where(sys_audit_trail_id: params[:audit_id]).first
    resque_info = Resque.info
    if resque_info[:workers] == 0
      admin = Role.where(:name => "Admin").first
      UserMailer.send_resque_error(admin.caos.first).deliver
      audit_trail.update_attributes( status: "2", upload_status: true, total_providers: providers.count )
      ProviderErrorLog.create( application_name: "OneStop Provisioning System", error_message: "Resque backgroud job fail: redis queue is not working", fk_audit_trail_id: @audit_trail.id)
    end
    render :json => audit_trail
  end

  private

  # Assign current user to session. 
  def find_cao
    @cao = current_cao
  end

  def find_application
    @application = RegisteredApp.find(params["provider"]["registered_app_id"])
  end

  def require_coa_login
    if @cao.is_admin?
      redirect_to admin_organizations_path
    end
  end

  # Start providers_queue to process uploaded cvs file
  def save_providers(providers)
    Resque.enqueue(BatchUpload, providers, @cao.id, @application.id, @audit_trail.id)
    resque_info = Resque.info
    if resque_info[:workers] == 0
      admin = Role.where(:name => "Admin").first
      UserMailer.send_resque_error(admin.caos.first).deliver
      @audit_trail.update_attributes( status: "2", upload_status: true, total_providers: providers.count )
      ProviderErrorLog.create( application_name: "OneStop Provisioning System", error_message: "Resque backgroud job fail: redis queue is not working", fk_audit_trail_id: @audit_trail.id)
    end
  end
  
  # Store uploaded file
  def store_csv
    upload = params[:upload]
    name =  upload.original_filename
    directory = "#{Rails.root}" + "/public/csv_files"
    Dir.mkdir(directory) unless File.exists?(directory)
    path = File.join(directory, name)
    File.open(path, "w") { |f| f.write(upload.read.gsub(/[\"\'\-\!\$\%\^\&\*\(\)\+\=\{\}\;\`\?\|\<\>\]\[]/, "")) }
    [path,name]
  end
  
  # Save Audit Trail record
  def save_audit_trails(file_name)
    audit = @cao.audit_trails.build(file_name: file_name, fk_registered_app_id: @application.id, total_providers: "0",
                            file_url: file_name, fk_organization_id: @cao.organization.id, total_npi_processed: 0)
    audit.save
    audit
  end

  def check_provider_duplicate_records(providers)
    temp_providers, duplicate_npis, duplicate_status = providers.to_s, [], true
    if @application.app_name.eql?("EPCS-IDP")
      npi_numbers = providers.collect { |p| p[:npi] }
      duplicate_npis = npi_numbers.select { |item| npi_numbers.count(item) > 1 }
      if duplicate_npis.present?
        temp = true
        duplicate_npis.uniq.each do |dup_npi|
          b = providers.collect{|x| x if dup_npi.eql?(x[:npi])}.compact
          b.collect{|x| x.delete(:npi)}
          duplicate_status = b.uniq.count == 1
          temp = temp && duplicate_status
        end
        duplicate_status = temp
      end
    end
    modified_providers = eval(temp_providers)
    [duplicate_status, duplicate_npis.uniq, modified_providers.uniq]
  end
end