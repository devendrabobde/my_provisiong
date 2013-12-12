class Admin::OrganizationsController < ApplicationController

  # Get all organizations
  def index
    @organizations = Organization.unscoped.all
  end

  # Get new organization form
  def new
   @organization = Organization.new
  end

  # Create an Organization. Next step after new.
  def create
   @organization = Organization.new(params[:organization])
    if @organization.save
      flash[:notice] = "Organization was created successfully."
      redirect_to admin_organization_path(@organization.id)
    else
      flash[:error] = @organization.errors.full_messages.join(",  ")
      render('new')
    end
  end

  # Get Details of an organization
  def show
    @organization = Organization.find(params[:id])
  end

  # Get edit organization form
  def edit
    @organization = Organization.find(params[:id])
  end

  # Update an organization with provided details. Step after edit
  def update
    @organization = Organization.find(params[:id])
    respond_to do |format|
    if @organization.update_attributes(params[:organization])
      flash[:notice] = "Organization was updated successfully."
      format.html { redirect_to admin_organization_path(@organization.id) }
    else
      flash[:error] = @organization.errors.full_messages.join(",  ")
      format.html { render :action => "edit",:id => @organization.id }
    end
    end
  end

  # Delete/Deactivate an organization
  def destroy
    @organization = Organization.find(params[:id])
    @organization.caos.each do |cao|
      cao.update_attributes(deleted_at: Time.now, deleted_reason: params["organization"]["deleted_reason"])
    end
    @organization.update_attributes(deleted_at: Time.now, deleted_reason: params["organization"]["deleted_reason"])

    redirect_to admin_organizations_path, :notice => "Organization " + @organization.name + " deactivated successfully."
  end

  # Change the state of an organization from inactive to active.
  def activate
    @organization = Organization.unscoped.find(params[:id])
    @organization.caos.each do |cao|
      cao.update_attributes(deleted_at: nil, deleted_reason: nil)
    end
    @organization.update_attributes(deleted_at: nil, deleted_reason: nil)
    redirect_to admin_organizations_path, :notice => "Organization " + @organization.name + " activated successfully."
  end

  # Get all the uploaded files for a particular organization and for a particular COA
  def show_uploaded_file
    @organization = Organization.unscoped.find(params[:id])
    @registered_applications = RegisteredApp.all
    if params[:registered_app_id].present?
      @audit_trails = @organization.audit_trails.where("fk_registered_app_id =? ", params[:registered_app_id]).order(:createddate)
    else
      if @registered_applications.first.present?
        @audit_trails = @organization.audit_trails.where("fk_registered_app_id =?", @registered_applications.first.id).order(:createddate)
      end
    end
    respond_to do |format|
      format.html
      format.js {
        result = render_to_string(partial: "/admin/organizations/uploaded_files", locals: { audit_trails: @audit_trails })
        render json: { html: result }
      }
    end
  end

  # Get a list of all providers for a particular organization and COA
  def show_provider
    provider_app_detail_ids = ProviderAppDetail.where(fk_audit_trail_id: params[:id])
    @providers = Provider.where("fk_provider_app_detail_id in (?)", provider_app_detail_ids)
    @audit_trail = AuditTrail.find(params[:id])
  end

  # Download the list of providers in CSV format.
  def download_provider
    provider_app_detail_ids = ProviderAppDetail.where(fk_audit_trail_id: params[:audit_id]).pluck(:sys_provider_app_detail_id)
    @providers = Provider.where("fk_provider_app_detail_id in (?)", provider_app_detail_ids)
    reg_app = AuditTrail.find(params[:audit_id]).registered_app

    respond_to do |format|
      format.html
      format.csv { send_data @providers.to_csv(reg_app, {}), :type => 'text/csv; charset=utf-8; header=present',
                   :disposition => "attachment; filename= #{reg_app.app_name}_Providers_#{DateTime.now.to_s}.csv" }
    end
  end
end