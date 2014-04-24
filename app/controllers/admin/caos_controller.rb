class Admin::CaosController < ApplicationController

  before_filter :find_value, only: [:new, :create, :edit, :update]
  skip_before_filter :check_update_password!
  # Eager load organizations with CAOs
  def index
    @organization = Organization.where("SYS_ORGANIZATION_ID = ?", params[:organization_id]).includes(:caos => [:role, :profile]).first
  end

  # Form for new CAO
  def new
    @organization = Organization.find(params[:organization_id])
    @cao = Cao.new
  end

  # Create a CAO. Next step after new.
  def create
    first_name = "#{params[:cao][:first_name].capitalize}"
    time = Time.now.to_i.to_s
    password = (first_name[0..5] + "@" + time[0..4])
    @organization = Organization.find(params[:organization_id])
    @cao = @organization.caos.create(params[:cao].merge!(password: password, password_confirmation: password, fk_role_id: Role.where(name: "COA").first.id))
    if @cao.save
      UserMailer.send_password(params[:cao], password).deliver
      flash[:notice] = VALIDATION_MESSAGE["COA"]["CREATE"]
      redirect_to admin_organization_cao_path(@organization.id, @cao.id)
    else
      flash[:error] = @cao.errors.full_messages.join(", ")
      render :action => :new, :id=> @organization.id
    end
  end

  # Get Details of a CAO
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
        flash[:notice] = VALIDATION_MESSAGE["COA"]["UPDATE"]
        format.html { redirect_to admin_organization_cao_path(@organization.id, @cao.id)}
      else
        flash[:error] = @cao.errors.full_messages.join(", ")
        format.html { render :action => "edit",:id => @organization.id }
      end
    end
  end

  # Delete a CAO (Basically, Deactivate the CAO)
  def destroy
    @organization = Organization.find(params[:organization_id])
    @cao          = Cao.find(params[:id])
    
    @cao.update_attributes(deleted_at: Time.now, deleted_reason: params["cao"]["deleted_reason"])
    UserMailer.account_deactivate(@cao).deliver
    redirect_to admin_organization_caos_path(@organization.id), :notice => VALIDATION_MESSAGE["COA"]["DEACTIVATE"]
  end

  # Revert an inactive CAO to active state. Thus, the CAO would be functional
  def activate
    @organization = Organization.find(params[:organization_id])
    @cao          = Cao.find(params[:id])
    @cao.update_attributes(deleted_at: nil, deleted_reason: nil)
    UserMailer.account_activate(@cao).deliver
    redirect_to admin_organization_caos_path(@organization.id), :notice => VALIDATION_MESSAGE["COA"]["ACTIVATE"]
  end

  private
  # Value pre-population
  def find_value
    @profile_list = Profile.all
    #@role_list = Role.where(name: "COA").first
  end
end
