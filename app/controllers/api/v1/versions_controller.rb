class Api::V1::VersionsController < ApplicationController

  skip_before_filter :authenticate_cao!
  skip_before_filter :check_update_password!
  # This method is responsible for verifying application up and runining status, DB status
  # and returns Hash of version_message, status, api_version
  def check_version
    var_error = nil
    status = 'ok'
    begin
      Provider.first
    rescue => error
      var_error = error
      status = 'fail'
    end
    version_message ='%s version %s is up and running at %s:%s.' % [
      'Onestop Provisioning App', SERVER_CONFIGURATION["onestop_code_version"], request.host, request.port ]
    if var_error.nil?
      db_status = "Onestop Provisioning is connected to database on account ID #{ActiveRecord::Base.connection_config[:username]}"
    else
      db_status = "Onestop Provisioning is currently experiencing problems with connecting to database. Error: #{var_error}"
    end
    render json: { version_message: version_message + db_status, status: status, api_version: SERVER_CONFIGURATION["onestop_code_version"], server_instance_name: ServerConfiguration::CONFIG['onestop_server_instance_name'] }
  end
end
