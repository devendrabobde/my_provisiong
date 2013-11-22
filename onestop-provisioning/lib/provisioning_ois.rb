module ProvisioningOis
  include OnestopRouter

  def self.batch_upload_dest(providers, cao, application)
    if application.app_name.eql?("EPCS-IDP")
      payload = { :providers => { "" => providers }, organization: cao.organization.attributes.symbolize_keys  }
      url = CONSTANT["EPCS_OIS"]["SERVER_URL"] + "/" + CONSTANT["EPCS_OIS"]["BATCH_UPLOAD_DEST_URL"]
      begin
        response = RestClient::Request.execute(:method => :post, :url => url , :payload => payload)
      rescue => e
        Rails.logger.error e
      end
    end
    providers_with_npi = []
    if providers.present?
      providers.each do |provider|
        provider = provider.symbolize_keys
        if provider[:npi].present?
          providers_with_npi << provider.slice(:npi, :first_name, :last_name)
        end
      end
    end
    if providers_with_npi.present?
      OnestopRouter::batch_upload(providers_with_npi, application)
    end
  end

end
