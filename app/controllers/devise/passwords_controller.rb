class Devise::PasswordsController < DeviseController
  prepend_before_filter :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_filter :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    if params[:forgot_field] == '1'
      self.resource = resource_class.send_username_via_email(resource_params)
    else
      self.resource = resource_class.send_reset_password_instructions(resource_params)
    end
    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    @coa = Cao.find_by_reset_password_token(params[:reset_password_token])
    check_valid_token = (@coa.present? && @coa.reset_password_period_valid?) rescue false
    if check_valid_token
      self.resource = resource_class.new
      resource.reset_password_token = params[:reset_password_token]
    else
      flash[:error] = VALIDATION_MESSAGE["COA"]["PASSWORD_RESET_LINK_EXPIRED"]
      redirect_to new_cao_password_path
    end
  end

  # PUT /resource/password
  def update
    @coa = Cao.find_by_reset_password_token(params[:cao][:reset_password_token])
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      resource.security_answer = nil
      respond_with resource
    end
  end

  protected
    def after_resetting_password_path_for(resource)
      after_sign_in_path_for(resource)
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_session_path(resource_name) if is_navigational_format?
    end

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:alert, :no_token)
        redirect_to new_session_path(resource_name)
      end
    end
end
