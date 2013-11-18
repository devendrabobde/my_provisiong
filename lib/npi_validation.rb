module NpiValidation

  # def self.validate(provider_record, field_validation)
  #   # find the application and validate application specific conditions
  #   response = []
  #   application = field_validation.app_upload_field.registered_app
  #   if application.app_name.eql?("EPCS-IDP")
  #     response = check_supernpi_acceptance(provider_record)
  #   end
  #   response
  # end
  # def self.check_supernpi_acceptance(provider)
  #   provider = provider.symbolize_keys
  #   provider_final_supernpi_status, super_npi_error_message = false, []
  #   npi, first_name, last_name = provider[:npi], provider[:first_name], provider[:last_name]
  #   if npi.present?
  #     begin
  #       url = CONSTANT["SUPERNPI_OIS"]["SERVER_URL"] + "/" + CONSTANT["SUPERNPI_OIS"]["VIEW_USER_URL"]
  #       response = RestClient.get url, params: { npi_code: npi }
  #       if response.present?
  #         response = JSON.parse(response)
  #         if response["status"] == 200
  #            supernpi_provider = response["provider_detail"].first
  #           # supernpi_provider = NpiMaster.join_result(npi).first
  #           if supernpi_provider.present?
  #             supernpi_provider_first_name = supernpi_provider["PROVIDER_FIRST_NAME"]
  #             supernpi_provider_last_name = supernpi_provider["PROVIDER_LAST_NAME"]
  #             provider_fullname_status = ((first_name == supernpi_provider_first_name) and (last_name == supernpi_provider_last_name))
  #             if provider_fullname_status
  #               provider_final_supernpi_status = true
  #             else
  #               super_npi_error_message << VALIDATION_MESSAGE["EPCS"]["SUPERNPI"]["PROVIDER_NAME_ERROR_MESSAGE"]
  #             end
  #           else
  #             super_npi_error_message << VALIDATION_MESSAGE["EPCS"]["SUPERNPI"]["PROVIDER_ERROR_MESSAGE"]
  #           end
  #         elsif response["status"] == 404
  #           super_npi_error_message << VALIDATION_MESSAGE["EPCS"]["SUPERNPI"]["PROVIDER_ERROR_MESSAGE"]
  #         end
  #       end
  #     rescue  => e
  #       super_npi_error_message << "SuperNPI OIS " + e.message
  #     end
  #   end
  #   [provider_final_supernpi_status, super_npi_error_message]
  # end


  def self.validate(providers, application)
    # find the application and validate application specific conditions
    response = providers
    # application = field_validation.app_upload_field.registered_app
    if application.app_name.eql?("EPCS-IDP")
      response = check_supernpi_acceptance(providers)
    end
    response
  end

  def self.check_supernpi_acceptance(providers_records)
    updated_providers = []
    begin
      url = CONSTANT["SUPERNPI_OIS"]["SERVER_URL"] + "/" + CONSTANT["SUPERNPI_OIS"]["VIEW_USER_URL"]
      # response = RestClient.get url, params: { providers: providers_records }
      modified_providers = providers_records
      modified_providers.each do |provider|
        provider[:provider_dea_record] = { "" => provider[:provider_dea_record]}
      end
      payload = { :providers => { "" => modified_providers } }
      response = RestClient::Request.execute(:method => :get, :url => url , :payload => payload )
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
    providers.present? ? providers : providers_records
  end
end