class Admin::ProvidersController < ApplicationController
  require 'csv'
  include ProvisioningOis
  include ProvisioingCsvValidation
  include OnestopRouter

  before_filter :find_cao
  before_filter :require_coa_login
  before_filter :find_application, :only => [:upload]
  before_filter :generate_required_object, only: :application
  skip_before_filter :check_update_password!, only: :application

  # Return list of uploaded files.
  def application
    unless session[:router_reg_applications]
      $regapps = OnestopRouter.request_batchupload_responders(@cao.organization)
      session[:router_reg_applications] = $regapps unless $regapps.first["errors"]
    else
      $regapps = session[:router_reg_applications]
    end
    
    if $regapps.first["errors"]
      @registered_applications = []
      flash[:error] = "Onestop Router Error: " +  $regapps.first["errors"].first["message"]
    else
      display_name = $regapps.collect{|x| x.values.flatten.collect{|y| "#{x.keys.first}::#{y['ois_name']}"}}.flatten      
      @registered_applications = RegisteredApp.where(display_name: display_name)
    end

    if params[:registered_app_id].present?
      @audit_trails = @cao.organization.audit_trails.where("fk_registered_app_id =?", params[:registered_app_id]).order(:createddate) rescue []
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

  def download_sample_file
    reg_app = RegisteredApp.find(params[:id])
    path, file_name = "", ""
    if reg_app.app_name.eql?(CONSTANT["APP_NAME"]["EPCS"])
      path = "#{Rails.root}/public/sample_csv_files/sample_epcs_providers.csv"
      file_name = "sample_epcs_providers.csv"      
    elsif reg_app.app_name.eql?(CONSTANT["APP_NAME"]["MOXY"])
      path = "#{Rails.root}/public/sample_csv_files/sample_moxy_providers.csv"
      file_name = "sample_moxy_providers.csv"
    elsif reg_app.app_name.eql?(CONSTANT["APP_NAME"]["RCOPIA"])
      path = "#{Rails.root}/public/sample_csv_files/sample_rcopia_providers.csv"
      file_name = "sample_rcopia_providers.csv"
    end
    send_file(path, type: 'text/csv; charset=utf-8; header=present', disposition: "attachment; filename=#{file_name}", url_based_filename: true)
  end

  def upload
    begin
      file_path, file_name = store_csv
      app_hash_router = router_reg_applications.collect{|x| x.values.flatten.select{|y| y if "#{x.keys.first}::#{y['ois_name']}" == @application.display_name}}.flatten.first rescue nil
      status, message, providers = ProvisioingCsvValidation::process_csv_api(file_path, @application, app_hash_router)
      if status
        @audit_trail = save_audit_trails(file_name)
        save_providers(providers, app_hash_router)
        flash[:notice] = message
        AuditTrailsLog.warn message
      else
        flash[:error] = message
        AuditTrailsLog.warn message
      end
    rescue => e
      puts e.inspect
      err = (e.class.to_s == "CSV::MalformedCSVError") ? "Error IN CSV File: " : "Error: "
      flash[:error] = err + e.message
    end
    redirect_to application_admin_providers_path(registered_app_id: @application.id)
  end

  # Pull audit trail record to verify file upload status
  def pull_redis_job_status
    audit_trail = AuditTrail.where(sys_audit_trail_id: params[:audit_id]).first
    resque_info = Resque.info
    if resque_info[:workers] == 0
      admin = Role.where(:name => "Admin").first
      UserMailer.send_resque_error(admin.caos.first).deliver
      audit_trail.update_attributes( status: "2", upload_status: true, total_providers: audit_trail.total_providers )
      ProviderErrorLog.create( application_name: CONSTANT["APP_NAME"]["ONESTOP"], error_message: VALIDATION_MESSAGE["PROVIDER"]["REDIS_Q_FAIL"], fk_audit_trail_id: audit_trail.id)
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

  # Start providers_queue to process uploaded csv file
  def save_providers(providers, app_hash_router)
    Resque.enqueue(BatchUpload, providers, @cao.id, @application.id, @audit_trail.id, app_hash_router)
    resque_info = Resque.info
    if resque_info[:workers] == 0
      admin = Role.where(:name => "Admin").first
      UserMailer.send_resque_error(admin.caos.first).deliver
      @audit_trail.update_attributes( status: "2", upload_status: true, total_providers: providers.count )
      ProviderErrorLog.create( application_name: CONSTANT["APP_NAME"]["ONESTOP"], error_message: VALIDATION_MESSAGE["PROVIDER"]["REDIS_Q_FAIL"], fk_audit_trail_id: @audit_trail.id)
    end
  end

  # Store uploaded file
  def store_csv
    upload = params[:upload]
    name =  upload.original_filename
    directory = "#{Rails.root}" + "/public/csv_files"
    path = File.join(directory, name)
    [path,name]
  end

  # Save Audit Trail record
  def save_audit_trails(file_name)
    audit = @cao.audit_trails.build(file_name: file_name, fk_registered_app_id: @application.id, total_providers: "0",
      file_url: file_name, fk_organization_id: @cao.organization.id, total_npi_processed: 0)
    audit.save
    audit
  end

  def get_audit_trails(registered_app_id, registered_applications)
    if registered_app_id.present?
      audit_trails = @cao.organization.audit_trails.where("fk_registered_app_id =?", registered_app_id).order(:createddate) rescue []
    else
      if registered_applications.first.present?
        audit_trails = @cao.organization.audit_trails.where(fk_registered_app_id: registered_applications.first.id).order(:createddate) rescue []
      end
    end
    return audit_trails
  end

  def generate_required_object
    @profile_list = Profile.all
  end
end