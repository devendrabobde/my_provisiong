class Admin::ProvidersController < ApplicationController
  require 'csv'
  include ProvisioningOis
  include ProvisioingCsvValidation

  before_filter :find_cao
  before_filter :require_coa_login
  before_filter :find_application, :only => [:upload]

  def application
    @registered_applications = RegisteredApp.all
    if params[:registered_app_id].present?
      @audit_trails = @cao.organization.audit_trails.where("fk_registered_app_id =?", params[:registered_app_id]).order(:createddate)
    else
      if @registered_applications.first.present?
        @audit_trails = @cao.organization.audit_trails.where(fk_registered_app_id: @registered_applications.first.id).order(:createddate)
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

  def show
    provider_app_detail_ids = @cao.organization.provider_app_details.where(fk_audit_trail_id: params[:id])
    @providers = Provider.where("fk_provider_app_detail_id in (?)", provider_app_detail_ids)
    @audit_trail = AuditTrail.find(params[:id])
    @upload_error = ProviderErrorLog.where(fk_audit_trail_id: @audit_trail.id).first
  end

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

  def upload
    error_message, success_message, invalid_providers = "", "", []
    file_path, file_name = store_csv
    providers = ProvisioingCsvValidation::process_csv(file_path, @application)
    if providers.present?
      required_field_status, required_field_errors, invalid_providers = ProvisioingCsvValidation::validate_required_field(providers, @application)
      if required_field_status
        @audit_trail = save_audit_trails(file_name)
        save_providers(providers)
        success_message = "Thanks for uploading providers, we are processing uploaded file."
      else
        error_message = "Providers required fields can't be blank, please correct " + required_field_errors.join(", ") + " fields before proceeding " + invalid_providers.join(", ")
      end
    else
      error_message = "Uploaded providers csv file is empty."
    end
    if error_message.present?
      flash[:error] = error_message
    else
      flash[:notice] = success_message
    end
    redirect_to application_admin_providers_path
  end

  def pull_redis_job_status
    audit_trail = AuditTrail.where(sys_audit_trail_id: params[:audit_id]).first
    render :json => audit_trail
  end

  private

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

  def save_providers(providers)
    Resque.enqueue(BatchUpload, providers, @cao.id, @application.id, @audit_trail.id)
  end

  def store_csv
    upload = params[:upload]
    name =  upload.original_filename
    directory = "#{Rails.root}" + "/public/csv_files"
    Dir.mkdir(directory) unless File.exists?(directory)
    path = File.join(directory, name)
    File.open(path, "w") { |f| f.write(upload.read) }
    [path,name]
  end

  def save_audit_trails(file_name)
    audit = @cao.audit_trails.build(file_name: file_name, fk_registered_app_id: @application.id, total_providers: "0",
                            file_url: file_name, fk_organization_id: @cao.organization.id, total_npi_processed: 0)
    audit.save
    audit
  end
end
