##
## This class is basically used for Exception handling
## Old Logic Before OIS Level Validations
# module ValidateRecord

#   #
#   # Raise exception if provider record field is not present o.w return true
#   #
#   def self.presence_validation(record, validation_field)
#     raise FieldPresenceError.new("Field #{validation_field.name} not present.") if record[validation_field.name.to_sym].blank? || record[validation_field.name.to_sym].nil?
#     return true
#   end

#   # User defined class for handling exception
#   class FieldPresenceError < StandardError
#   end
# end


#
# This class is basically used for Processing CSV and Validating providers records
#
module ProvisioingCsvValidation

  # include ValidateRecord


  def self.process_csv_api(path, router_reg_applications)
    status, message, providers = false, nil, []
    csv_record = CSV.read(path, :col_sep=>',', :headers => true)
    providers = csv_record.collect{|x| x.to_hash }.delete_if{|p| p.nil? }
    url = "http://localhost:3002/api/v1/ois/validations/validate-csv.json"
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
      message = "OIS #{router_reg_applications["ois_name"]}: " + e.message
    ensure
      Rails.logger.info \
        "Provisioning- process_csv_api(): Communication summary:\n\nURL:#{url}\n\nSent:\
          \n\n#{payload}\n\nReceived:\n\n#{providers}"
    end
    [status, message, providers]
  end

  #
  # Processing providers CSV file
  # Old Logic Before OIS Level Validations
  # def self.process_csv(path, application)
  #   providers,csv_headers,upload_headers  = [], [], []
  #   app_upload_fields = application_upload_field_validations(application)
  #   CSV.foreach(path, :col_sep=>',', :headers => true) do |row|
  #     provider_record = row.to_hash
  #     providers << process_record(provider_record, application, app_upload_fields) if provider_record.present?
  #     csv_headers = row.headers unless csv_headers.present?
  #   end
  #   # Code for checking cross-application CSV upload to differentiate application upload based on CSV headers and app_upload_fields
  #   upload_headers = app_upload_fields.collect(&:display_name).sort
  #   if application.app_name.eql?(CONSTANT["APP_NAME"]["EPCS"])
  #     upload_headers = upload_headers[1..10]
  #     csv_headers = csv_headers.include?("FQDN") ? csv_headers.sort[1..10] : csv_headers.sort[0..9]
  #   else
  #     upload_headers = upload_headers[0..9]
  #     csv_headers = csv_headers.sort[0..9]
  #   end
  #   status = (csv_headers == upload_headers)
  #   # File.delete(path) if File.exist?(path)
  #   file_status = providers.present? ? true : false
  #   [providers, file_status, status]
  # end

  #
  #  Mapping providers CSV data with model field based on display name
  #  Old Logic Before OIS Level Validations
  # def self.process_record(record, application, app_upload_fileds)
  #   provider = {}
  #   record.each do |key,value|
  #     key = key.strip rescue nil
  #     app_upload_fileds.each do |field|
  #       if field.display_name == key
  #         provider[field.name] = value.strip rescue nil
  #       end
  #     end
  #   end
  #   provider = provider.symbolize_keys
  #   if [CONSTANT["APP_NAME"]["EPCS"], CONSTANT["APP_NAME"]["RCOPIA"]].include?(application.app_name)
  #     provider_dea_info, dea_numbers, dea_states, dea_expiration_times = [], [], [], []
  #     if provider[:provider_dea].present?
  #       dea_numbers = provider[:provider_dea].strip.split("~")
  #     end
  #     if provider[:provider_dea_state].present?
  #       dea_states = provider[:provider_dea_state].strip.split("~")
  #     end
  #     if provider[:provider_dea_expiration_date].present?
  #       dea_expiration_times = provider[:provider_dea_expiration_date].strip.split("~")
  #     end
  #     if dea_numbers.present?
  #       dea_result = dea_numbers.each_with_index.collect{|x, i| [x, dea_states[i], dea_expiration_times[i]]}
  #       provider_dea_info = dea_result.collect{|x|{ provider_dea: x[0], provider_dea_state: x[1], provider_dea_expiration_date: x[2] }}
  #     elsif dea_states.present?
  #       dea_result = dea_states.each_with_index.collect{|x, i| [dea_numbers[i], x, dea_expiration_times[i]]}
  #       provider_dea_info = dea_result.collect{|x|{ provider_dea: x[0], provider_dea_state: x[1], provider_dea_expiration_date: x[2] }}
  #     elsif dea_expiration_times.present?
  #       dea_result = dea_expiration_times.each_with_index.collect{|x, i| [dea_numbers[i], dea_states[i], x] }
  #       provider_dea_info = dea_result.collect{|x|{ provider_dea: x[0], provider_dea_state: x[1], provider_dea_expiration_date: x[2] }}
  #     end
  #     provider[:provider_dea_record] = provider_dea_info
  #     provider = provider.except(:provider_dea, :provider_dea_state, :provider_dea_expiration_date)
  #   end
  #   provider
  # end

  #
  # Get application validation fields
  # Old Logic Before OIS Level Validations
  # def self.application_upload_field_validations(application)
  #   # Added validations from redis server which reduce time consumption
  #   cached_store_validation = RedisCache.get_validation_cached(application.app_name)
  #   validation_fields = cached_store_validation.present? ? cached_store_validation : application.app_upload_fields.includes(:app_upload_field_validations)
  # end

  #
  # This method is responsible for validating providers record. In this we are checking present field condition.
  # Old Logic Before OIS Level Validations
  # def self.validate_required_field(providers, application)
  #   required_field_errors = []
  #   provider_keys, provider_dea_keys = [], []
  #   req_field_err_hash = {}
  #   provider_validations = application_upload_field_validations(application)
  #   provider_validations = provider_validations.each.select {|v| v.required }
  #   providers.each_with_index do |provider, index|
  #     req_field_err_hash[index] = [ ]
  #     if provider.present?
  #       provider_keys = provider.keys
  #       if provider[:provider_dea_record].present?
  #         dea_numbers = provider[:provider_dea_record]
  #         provider_dea_keys = dea_numbers.first.keys
  #       end
  #       provider_validations.each do |vf|
  #         begin
  #           if vf.required?
  #             if provider_keys.include? vf.name.to_sym
  #               ValidateRecord.presence_validation(provider, vf)
  #             end
  #             if provider_dea_keys.include? vf.name.to_sym
  #               if dea_numbers.present?
  #                 dea_numbers.each do |dea_number|
  #                   ValidateRecord.presence_validation(dea_number, vf)
  #                 end
  #               end
  #             end
  #           else
  #             next
  #           end
  #         rescue ValidateRecord::FieldPresenceError => e
  #           required_field_errors << vf.name
  #           req_field_err_hash[index] << vf.name
  #           # invalid_providers << provider
  #         end
  #       end
  #     end
  #   end
  #   required_field_status = required_field_errors.present? ? false : true
  #   required_field_errors = required_field_errors.uniq.compact.map!{ |c| c.titleize.strip }
  #   [required_field_status, req_field_err_hash]
  # end

  #
  # # This method is responsible for applying different validation classes to verify providers record
  # # Old Logic Before OIS Level Validations
  # def self.validate_provider(providers, application, upload_field_validations)
  #   modified_providers, valid_providers, invalid_providers = [], [], []
  #   providers.each do |provider|
  #     if provider.present?
  #       provider = provider.symbolize_keys
  #       provider_error_messages = []
  #       upload_field_validations.each do |f_validation|
  #         f_validation.app_upload_field_validations.each do |field_validation|
  #           validation_class = field_validation.validation.classify
  #           if (validation_class != "Npi")
  #             validate, error_message = class_eval((validation_class + "Validation")).validate(provider, field_validation) rescue nil
  #             unless validate
  #               provider_error_messages << error_message
  #             end
  #           end
  #         end
  #       end
  #       provider_error_messages = provider_error_messages.flatten.compact
  #       provider[:validation_error_message] = provider_error_messages.flatten.join(", ")
  #       modified_providers << provider
  #     end
  #   end
  #   modified_providers.each do |provider|
  #     if provider[:validation_error_message].present?
  #       invalid_providers << provider
  #     else
  #       valid_providers << provider
  #     end
  #   end
  #   # validated_providers = class_eval(("NpiValidation")).validate(modified_providers, application) rescue nil
  #   validated_providers = class_eval(("NpiValidation")).validate(valid_providers, application) rescue nil
  #   total_providers = validated_providers.present? ? validated_providers + invalid_providers : invalid_providers
  #   total_providers
  # end

  def self.validate_provider_api(providers, router_reg_applications)
    valid_providers, invalid_providers, total_providers = [], [], []
    url = "http://localhost:3002/api/v1/ois/validations/validate-provider.json"
    mod_providers = providers.collect do |provider|
        provider = provider.symbolize_keys
        provider[:provider_dea_record] = { "" => provider[:provider_dea_record] }
        provider
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
        end
      end
    rescue => e
      Rails.logger.error e
      total_providers = providers.collect do |x| 
        x = x.symbolize_keys
        x[:validation_error_message] = e.message
      end 
    ensure
      Rails.logger.info \
        "Provisioning- validate_provider_api(): Communication summary:\n\nURL:#{url}\n\nSent:\
          \n\n#{payload}\n\nReceived:\n\n#{rec_providers}"
    end
    total_providers
  end

end
