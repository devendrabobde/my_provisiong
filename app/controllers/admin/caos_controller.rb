class Admin::CaosController < ApplicationController

  before_filter :find_value, only: [:new, :create, :edit, :update]

  def index
    @organization = Organization.where("SYS_ORGANIZATION_ID = ?", params[:organization_id]).includes(:caos => [:role, :profile]).first
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.new
  end

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

  def show
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
  end

  def edit
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
  end

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

  def destroy
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
    @cao.update_attributes(deleted_at: Time.now, deleted_reason: params["cao"]["deleted_reason"])
    redirect_to admin_organization_caos_path(@organization.id), :notice => "COA " + @cao.username + " deactivated successfully."
  end

  def activate
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.find(params[:id])
    @cao.update_attributes(deleted_at: nil, deleted_reason: nil)
    redirect_to admin_organization_caos_path(@organization.id), :notice => "COA " + @cao.username + " activated successfully."
  end

  private
  def find_value
    @profile_list = Profile.all
    @role_list = Role.where(name: "COA")
  end
end
