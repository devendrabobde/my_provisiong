#
# This class is basically used to validate providers NPI number
#
module NpiValidation

  #
  # Find the application and verify application specific conditions, for EPCS we are verifying providers against SuperNPI DB
  #
  def self.validate(providers)
    # response = providers
    #
    # validate providers npi checksum
    #
    response, invalid_npi_providers = validate_provider_npi(providers)

    if providers.first.keys.include?(:npi)
      request_time = Time.now
      response = check_supernpi_acceptance(response)
      response_time = Time.now
      Rails.logger.info "Benchmarking - SUPERNPI OIS - NpiValidation elapsed time:#{response_time - request_time} sec"
    end
    response + invalid_npi_providers
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
      Rails.logger.error e
      providers_records.each do |provider|
        provider[:validation_error_message] = "SuperNPI OIS " + e.message
        provider[:status] = "500"
        updated_providers <<  provider
      end
      providers = updated_providers
    ensure
      Rails.logger.info \
        "Onestop-Provisioning: SuperNPI-OIS communication summary:\n\nURL:#{url}\n\nSent to SuperNPI-OIS:\
          \n\n#{payload}\n\nReceived from SuperNPI-OIS:\n\n#{providers rescue nil}"
    end
    providers.present? ? providers : []
  end

  def self.validate_provider_npi(providers)
    invalid_npi_provs = []
    provs = []
    providers.each do |provider|
      if provider[:npi].blank?
        provs << provider
      else
        npi = provider[:npi]
        if npi.length == 10
          sum = 0
          for i in 0..npi.length - 2
            if i % 2 == 0
              num = npi[i].to_i * 2
              sum += num >= 10 ? (1 + num - 10) :  num
            else
              sum += npi[i].to_i
            end
          end
          sum += 24
          round = sum.round(-1) >= sum ? sum.round(-1) : sum.round(-1) + 10
          check = round - sum
          if npi[-1].to_i == check
            provs << provider
          else
            provider[:validation_error_message] = VALIDATION_MESSAGE["EPCS"]["NPI_NUMBER"]["CHECKSUM_ERROR_MESSAGE"]
            invalid_npi_provs << provider
          end
        end
      end
    end
    [provs, invalid_npi_provs]
  end
end
