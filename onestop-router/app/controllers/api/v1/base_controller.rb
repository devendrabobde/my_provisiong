class Api::V1::BaseController < ApplicationController
  before_filter :set_default_response_format

  respond_to :json

  protected
    def set_default_response_format
      request.format = :json if params[:format].nil?
    end

    def success_with(object)
      request_successful
      respond_with(object)
    end

    def request_successful
      headers['ResponseStatus'] = 'success'
      headers['ErrorCategory']  = 'request'
      headers['ErrorCode']      = ''
      headers['ErrorMessage']   = ''
    end
end
