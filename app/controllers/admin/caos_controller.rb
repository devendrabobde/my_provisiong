class Admin::CaosController < ApplicationController

  before_filter :find_value, only: [:new, :create, :edit, :update]

  # Eager load organizations with CAOs
  def index
    @organization = Organization.where("SYS_ORGANIZATION_ID = ?", params[:organization_id]).includes(:caos => [:role, :profile]).first
    #@caos =  @organization.caos
  end

  # Form for new CAO
  def new
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.new
  end

  # Create a CAO. Next step after new.
  def create
    @organization = Organization.find(params[:organization_id])
    @cao = @organization.caos.create(params[:cao])
    if @cao.save
      flash[:notice] = "COA was created successfully."
      redirect_to admin_organization_cao_path(@organization.id, @cao.id)
    else
      flash[:error] = @cao.errors.full_messages.join(", ")
      render :action => :new, :id=> @organization.id
    end
  end

  # get Details of a CAO
  def show
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
  end

  # Edit a particular CAO
  def edit
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
  end

  # Update a CAO with changes
  def update
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
    respond_to do |format|
      if @cao.update_attributes(params[:cao])
        flash[:notice] = "COA was updated successfully."
        format.html { redirect_to admin_organization_cao_path(@organization.id, @cao.id)}
      else
        flash[:error] = @cao.errors.full_messages.join(", ")
        format.html { render :action => "edit",:id => @organization.id }
      end
    end
  end

  # Delete a CAO (Basically, deactivate the CAO)
  def destroy
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
    @cao.update_attributes(deleted_at: Time.now, deleted_reason: params["cao"]["deleted_reason"])
    redirect_to admin_organization_caos_path(@organization.id), :notice => "COA " + @cao.username + " deactivated successfully."
  end

  # Revert an inactive CAO to active state. Thus, the CAO would be functional
  def activate
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
    @cao.update_attributes(deleted_at: nil, deleted_reason: nil)
    redirect_to admin_organization_caos_path(@organization.id), :notice => "COA " + @cao.username + " activated successfully."
  end

  private
  # Value pre-population
  def find_value
    @profile_list = Profile.all
    @role_list = Role.where(name: "COA")
  end
end
