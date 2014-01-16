#
# This class is basically used to validate providers NPI number
#
module NpiValidation

  #
  # Find the application and verify application specific conditions, for EPCS we are verifying providers against SuperNPI DB 
  #
  def self.validate(providers, application)
    response = providers
    if application.app_name.eql?("EPCS-IDP")
      response = check_supernpi_acceptance(providers)
    end
    response
  end
  
  #
  # view_user method call. For validating provider npi number.
  #
  def self.check_supernpi_acceptance(providers_records)
    updated_providers = []
    begin
      url = CONSTANT["SUPERNPI_OIS"]["SERVER_URL"] + "/" + CONSTANT["SUPERNPI_OIS"]["VIEW_USER_URL"]
      modified_providers = providers_records
      modified_providers.each do |provider|
        provider[:provider_dea_record] = { "" => provider[:provider_dea_record]}
      end
      payload = { :providers => { "" => modified_providers } }
      response = RestClient::Request.execute(:method => :get, :url => url , :payload => payload, :timeout => 720 )
      if response.present?
        response = JSON.parse(response)
        providers = response["valid_providers"] + response["invalid_providers"]
      end
    rescue  => e
      providers_records.each do |provider|
        provider[:validation_error_message] = "SuperNPI OIS " + e.message
        updated_providers <<  provider
      end
      providers = updated_providers
    end
    providers.present? ? providers : []
  end
end
