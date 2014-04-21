class MonitorController < ApplicationController
	skip_before_filter :authenticate_cao!

	def monitor
		provisioning_connectivity = get_provisiong_details
		super_npi_connectivity    = verify_connectivity("#{CONSTANT["SUPERNPI_OIS"]["SERVER_URL"]}/#{CONSTANT["SUPERNPI_OIS"]["VERIFY_CONNECTIVITY"]}")
		epcs_connectivity         = verify_connectivity("#{CONSTANT["EPCS_OIS"]["SERVER_URL"]}/#{CONSTANT["EPCS_OIS"]["VERIFY_CONNECTIVITY"]}")
		router_connectivity       = verify_connectivity("#{CONSTANT["ONESTOP_ROUTER"]["SERVER_URL"]}/#{CONSTANT["ONESTOP_ROUTER"]["VERIFY_CONNECTIVITY"]}")
    @connectivity             = { provisioning: provisioning_connectivity, epcs: epcs_connectivity, super_npi: super_npi_connectivity, router: router_connectivity }

    p "======="
    p @connectivity
    p "======="
	end

	private

	def verify_connectivity(url)
		begin
			return ActiveSupport::JSON.decode(RestClient.get(url))
		rescue => e
			return { "result" => false }
		end
	end

  def get_provisiong_details
    var_error = nil
    status = 'ok'
    begin
      Provider.first
    rescue => error
      var_error = error
      status = 'fail'
    end
    version_message ='%s version %s is up and running at %s:%s.' % [
      'Onestop Provisioining App', SERVER_CONFIGURATION["onestop_code_version"], request.host, request.port ]
    if var_error.nil?
      db_status = "Onestop Provisioining is connected to database on account ID #{ActiveRecord::Base.connection_config[:username]}"
    else
      db_status = "Onestop Provisioining is currently experiencing problems with connecting to database. Error: #{var_error}"
    end
    
    json_response = { version_message: version_message + db_status, status: status, api_version: SERVER_CONFIGURATION["onestop_code_version"], server_instance_name: ServerConfiguration::CONFIG['onestop_server_instance_name'] }
    p "-----------"
    p json_response
    p "-----------"
    return json_response
  end

end
