#
# This class is responsible for uploading the providers information in specific OIS application
#
module ProvisioningOis
  include OnestopRouter

  #
  # This method is responsible for uploading the providers information in specific OIS application
  #
  def self.batch_upload_dest(providers, cao, application)
    updated_providers = []
    if application.app_name.eql?("EPCS-IDP")
      payload = { :providers => { "" => providers }, organization: cao.organization.attributes.symbolize_keys  }
      url = CONSTANT["EPCS_OIS"]["SERVER_URL"] + "/" + CONSTANT["EPCS_OIS"]["BATCH_UPLOAD_DEST_URL"]
      begin
        response = RestClient::Request.execute(:method => :post, :url => url , :payload => payload, :timeout=> 600)
        response = JSON.parse(response)
        provider_records = response["providers"]
      rescue => e
        Rails.logger.error e
        providers.each do |provider|
          provider[:error] = application.app_name + " " + e.message
          updated_providers <<  provider
        end
        provider_records = updated_providers
      end
    end
    providers_with_npi, invalid_providers, batch_upload_response = [], [], nil

    # if providers.present?
    #   providers.each do |provider|
    #     provider = provider.symbolize_keys
    #     if provider[:npi].present?
    #       providers_with_npi << provider.slice(:npi, :first_name, :last_name)
    #     end
    #   end
    # end
    if provider_records.present?
      provider_records.each do |provider|
        provider = provider.symbolize_keys
        if !provider[:error].present? and provider[:npi].present?
          providers_with_npi << provider.slice(:npi, :first_name, :last_name)
        else
          invalid_providers << provider
        end
      end
    end
    if providers_with_npi.present?
      batch_upload_response = OnestopRouter::batch_upload(providers_with_npi, application)
    end
    [invalid_providers, batch_upload_response]
  end
end