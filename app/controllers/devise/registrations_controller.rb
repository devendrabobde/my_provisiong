class Devise::RegistrationsController < DeviseController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  before_filter :generate_required_object, only: [:edit, :update]
  skip_before_filter :check_update_password!, only: :update
  # skip_before_filter :check_update_password!, only: :edit, :if => proc { current_coa.is_admin? }
  # GET /resource/sign_up
  def new
    build_resource({})
    respond_with self.resource
  end

  # POST /resource
  def create
    account_create_parameters = params[:cao]
    # build_resource(sign_up_params)
    build_resource(account_create_parameters)
    if resource.save
      # if resource.active_for_authentication?
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_up(resource_name, resource)
      respond_with resource, :location => after_sign_up_path_for(resource)
      # else
      #   set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
      #   expire_session_data_after_sign_in!
      #   respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      # end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    account_update_parameters = params[:cao]
    if params[:cao][:password].present?
      @password = true
      update = resource.update_with_password(account_update_parameters)
    else
      @password = false
      update = resource.update_without_password(account_update_parameters)
    end
    if update
      @password.eql?(true) ? UserMailer.update_password(resource).deliver : UserMailer.update_account(resource).deliver
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    elsif params[:redirect_from] == "popup"
      flash[:notice] = resource.errors.full_messages.map { |msg| msg }.join(" ")
      redirect_to application_admin_providers_path
    else
      # clean_up_passwords resource
      # respond_with resource
      flash[:error] = resource.errors.full_messages.map { |msg| msg }.join(" ")
      redirect_to application_admin_providers_path
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  # def after_inactive_sign_up_path_for(resource)
  #   respond_to?(:root_path) ? root_path : "/"
  # end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    if resource.is_admin?
      admin_organizations_path
    else
      # application_admin_providers_path
      application_admin_providers_path
    end
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  # def sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up)
  # end

  # def account_update_params
  #   devise_parameter_sanitizer.for(:account_update)
  # end

  def generate_required_object
    @profile_list = Profile.all
  end
end
