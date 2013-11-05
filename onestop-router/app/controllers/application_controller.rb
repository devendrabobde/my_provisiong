class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_client_id

  rescue_from OneStopError,                   :with => :handle_onestop_error
  rescue_from ActiveRecord::RecordNotFound,   :with => :not_found
  rescue_from ActionController::RoutingError, :with => :not_found

  def current_user
    current_admin_user
  end

  def set_client_id
    env['client_id'] = nil
  end

  protected
  def user_params
    params.permit(:npi, :first_name, :last_name, :enabled)
  end

  def not_found
    handle_onestop_error OneStopRequestError.new(code: 'not-found', message: 'Record not found', status: :ok)
  end

  def handle_onestop_error(exception)
    headers['ResponseStatus'] = 'error'
    headers['ErrorCategory']  = exception.category
    headers['ErrorCode']      = exception.code
    headers['ErrorMessage']   = exception.message

    render :json   => { :errors => [ exception ] },
           :status => exception.status
  end
end
