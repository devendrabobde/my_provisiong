class MonitorController < ApplicationController
	skip_before_filter :authenticate_cao!

	def monitor
		#onestop_database 		= Provider.first
		super_npi_connectivity 	= verify_connectivity("#{CONSTANT["SUPERNPI_OIS"]["SERVER_URL"]}/#{CONSTANT["SUPERNPI_OIS"]["VERIFY_CONNECTIVITY"]}")
		epcs_connectivity 		= verify_connectivity("#{CONSTANT["EPCS_OIS"]["SERVER_URL"]}/#{CONSTANT["EPCS_OIS"]["VERIFY_CONNECTIVITY"]}")
		router_connectivity 	= verify_connectivity("#{CONSTANT["ONESTOP_ROUTER"]["SERVER_URL"]}/#{CONSTANT["ONESTOP_ROUTER"]["VERIFY_CONNECTIVITY"]}")
		@connectivity 			= { epcs: epcs_connectivity["result"], super_npi: super_npi_connectivity["result"], router: router_connectivity["result"] }

	end

	private

	def verify_connectivity(url)
		begin
			return ActiveSupport::JSON.decode(RestClient.get(url))
		rescue => e
			return { "result" => false }
		end
	end
end
