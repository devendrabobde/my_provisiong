#
# This class is basically used for Processing CSV and Validating providers records
#
module ProvisioingCsvValidation
  # Call OIS API to validate csv file

  def self.process_csv_api(path, application, app_hash_router)
    status, message, providers = false, nil, []
    csv_record = CSV.read(path, :col_sep=>',', :headers => true)
    providers = csv_record.collect{|x| x.to_hash }.delete_if{|p| p.nil? }
    # url = "http://localhost:3002/api/v1/ois/validations/validate-csv.json"
    url = app_hash_router['validate_csv_url'] rescue nil
    payload = {:providers => {"" => providers}}
    begin
      response = RestClient::Request.execute(:method => :post, :url => url , :payload => payload, :timeout=> 600)
      response = JSON.parse(response)
      providers = response["providers"]
      message = response["message"]
      status = providers.blank? ? false : true
    rescue => e
      Rails.logger.error e
      status = false
      message = "OIS #{router_reg_applications["ois_name"] rescue nil}: " + e.message
    ensure
      Rails.logger.info \
        "Provisioning- process_csv_api(): Communication summary:\n\nURL:#{url}\n\nSent:\
          \n\n#{payload}\n\nReceived:\n\n#{providers}"
    end
    [status, message, providers]
  end

  def self.validate_provider_api(providers, application, app_hash_router)
    valid_providers, invalid_providers, total_providers = [], [], []
    # url = "http://localhost:3002/api/v1/ois/validations/validate-provider.json"
    url = app_hash_router['validate_provider_url'] rescue "" 
    if providers.first.keys.include? "provider_dea_record"
      mod_providers = providers.collect do |provider|
          provider = provider.symbolize_keys
          provider[:provider_dea_record] = { "" => provider[:provider_dea_record] }
          provider
      end
    else
      mod_providers = providers
    end
    payload = {:providers => {"" => mod_providers}}
    begin
      response = RestClient::Request.execute(:method => :post, :url => url , :payload => payload, :timeout=> 600)
      response = JSON.parse(response)
      rec_providers = response["validated_providers"]
      if rec_providers
        rec_providers.each do |provider|
          if provider.present?
            provider = provider.symbolize_keys
            if provider[:validation_error_message].present?
              invalid_providers << provider
            else
              valid_providers << provider
            end
          end
        end
        validated_providers = class_eval(("NpiValidation")).validate(valid_providers) rescue nil
        total_providers = validated_providers.present? ? validated_providers + invalid_providers : invalid_providers
        total_providers
      else
        total_providers = providers.collect do |x|
          x = x.symbolize_keys 
          x[:validation_error_message] = VALIDATION_MESSAGE["PROVIDER"]["VALIDATION_UNSUCCESSFUL"] + router_reg_applications["ois_name"]
          x
        end
      end
    rescue => e
      Rails.logger.error e
      total_providers = providers.collect do |x| 
        x = x.symbolize_keys
        x[:validation_error_message] = e.message
        x
      end 
    ensure
      Rails.logger.info \
        "Provisioning- validate_provider_api(): Communication summary:\n\nURL:#{url}\n\nSent:\
          \n\n#{payload}\n\nReceived:\n\n#{rec_providers}"
    end
    total_providers
  end

end
