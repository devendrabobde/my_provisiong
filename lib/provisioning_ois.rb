#
# This class is responsible for uploading the providers information in specific OIS application
#
module ProvisioningOis
  include OnestopRouter

  #
  # This method is responsible for uploading the providers information in specific OIS application
  #
  def self.batch_upload_dest(providers, cao, application, app_hash_router) 
    updated_providers = []
    app_url = app_hash_router['batch_upload_url'] rescue ""
    if providers.first.keys.include? :provider_dea_record
      providers = providers.collect do |provider|
        provider[:provider_dea_record] = { "" => provider[:provider_dea_record] }
        provider
      end
    end
    payload = { :providers => { "" => providers }}
    if application.app_name.eql?(CONSTANT["APP_NAME"]["EPCS"])
      vendor_details = {
        vendor_name: cao.epcs_vendor_name,
        vendor_password: cao.epcs_vendor_password
      }
      payload = payload.merge(organization: cao.organization.attributes.symbolize_keys, vendor_details: vendor_details)
      # if Rails.env == "test"
      #   app_url = CONSTANT["EPCS_OIS"]["TEST_SERVER_URL"] + "/" + CONSTANT["EPCS_OIS"]["BATCH_UPLOAD_DEST_URL"]
      # end
    elsif application.app_name.eql?(CONSTANT["APP_NAME"]["RCOPIA"])
      vendor_details = {
        vendor_name: cao.rcopia_vendor_name,
        vendor_password: cao.rcopia_vendor_password
      }
      payload = payload.merge(vendor_details: vendor_details)
      # if Rails.env == "test"
      #   app_url = CONSTANT["RCOPIA_OIS"]["TEST_SERVER_URL"] + "/" + CONSTANT["RCOPIA_OIS"]["BATCH_UPLOAD_DEST_URL"]
      # end
    elsif application.app_name.eql?(CONSTANT["APP_NAME"]["MOXY"])
      payload = payload.merge(organization: cao.organization.attributes.symbolize_keys)
      # if Rails.env == "test"
      #   app_url = CONSTANT["MOXY_OIS"]["TEST_SERVER_URL"] + "/" + CONSTANT["MOXY_OIS"]["BATCH_UPLOAD_DEST_URL"]
      # end
    end

    # Call Batch Upload
    begin
      request_time = Time.now
      response = RestClient::Request.execute(:method => :post, :url => app_url, :payload => payload, :timeout=> 600)
      Rails.logger.info "Benchmarking - #{ app_hash_router['ois_name'] rescue "" } OIS - btach_upload_dest() elapsed time:#{Time.now - request_time} sec"
      response = JSON.parse(response)
      provider_records = response["providers"]
    rescue => e
      Rails.logger.error e
      providers.each do |provider|
        provider[:error] = application.app_name + " " + e.message
        updated_providers <<  provider
       end
      provider_records = updated_providers
    ensure
      Rails.logger.info \
        "Provisioning- batch_upload_dest(): #{ app_hash_router['ois_name'] rescue "" } OIS communication summary:\n\nURL:#{app_url}\n\nSent to #{ app_hash_router['ois_name'] rescue "" } OIS:\
          \n\n#{payload}\n\nReceived from #{ app_hash_router['ois_name'] rescue "" } OIS:\n\n#{provider_records}"
     end

    # Process the response
    providers_with_npi, invalid_providers, npiless_providers, batch_upload_response,temp_providers = [], [], [], nil, []
    if provider_records.present?
      provider_records.each do |provider|
        provider = provider.symbolize_keys
        if provider[:status] == "902"
          status_codes = []
          provisioing_providers = Provider.where(npi: provider[:npi]).all
          provisioing_providers.each do |p|
            status_codes << p.provider_app_detail.status_code rescue nil
          end
          unless status_codes.compact.include? "200"
            temp_providers << provider
            providers_with_npi << provider.slice(:npi, :first_name, :last_name, :sys_provider_app_detail_id, :address_1, :address_2, :city, :state, :zip, :email, :middle_name, :prefix, :gender, :birth_date, :social_security_number)
          end
        end
        if !provider[:error].present? and provider[:npi].present?
          providers_with_npi << provider.slice(:npi, :first_name, :last_name, :sys_provider_app_detail_id, :address_1, :address_2, :city, :state, :zip, :email, :middle_name, :prefix, :gender, :birth_date, :social_security_number)
        elsif !provider[:error].present? and !provider[:npi].present?
          npiless_providers << provider
        else
          invalid_providers << provider
        end
      end
    end
    # Router Batch Upload
    if providers_with_npi.present?
      request_time = Time.now
      batch_upload_response = OnestopRouter::batch_upload(providers_with_npi, application, app_hash_router)
      response_time = Time.now
      Rails.logger.info "Benchmarking - Onestop Router - batch_upload() elapsed time:#{response_time - request_time} sec"
    end
    [invalid_providers - temp_providers, npiless_providers, batch_upload_response]
  end
end