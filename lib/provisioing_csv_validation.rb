module ValidateRecord

  def self.presence_validation(record, validation_field)
    raise FieldPresenceError.new("Field #{validation_field.name} not present.") if record[validation_field.name.to_sym].blank? || record[validation_field.name.to_sym].nil?
    return true
  end

  class FieldPresenceError < StandardError
  end
end

module ProvisioingCsvValidation

  include ValidateRecord

  def self.process_csv(path, application)
    providers = []
    app_upload_fileds = application.app_upload_fields
    CSV.foreach(path, :col_sep=>',', :headers => true) do |row|
      provider_record = row.to_hash
      providers << process_record(provider_record, application, app_upload_fileds) if provider_record.present?
    end
    providers
  end

  def self.process_record(record, application, app_upload_fileds)
    provider = {}
    record.each do |key,value|
      app_upload_fileds.each do |field|
        if field.display_name == key
          provider[field.name] = value
        end
      end
    end
    provider = provider.symbolize_keys
    if application.app_name.eql?("EPCS-IDP")
      provider_dea_info, dea_numbers, dea_states, dea_expiration_times = [], [], [], []
      if provider[:provider_dea].present?
        dea_numbers = provider[:provider_dea].strip.split("~")
      end
      if provider[:provider_dea_state].present?
        dea_states = provider[:provider_dea_state].strip.split("~")
      end
      if provider[:provider_dea_expiration_date].present?
        dea_expiration_times = provider[:provider_dea_expiration_date].strip.split("~")
      end
      if dea_numbers.present?
        dea_result = dea_numbers.each_with_index.collect{|x, i| [x, dea_states[i], dea_expiration_times[i]]}
        provider_dea_info = dea_result.collect{|x|{ provider_dea: x[0], provider_dea_state: x[1], provider_dea_expiration_date: x[2] }}
      elsif dea_states.present?
        dea_result = dea_states.each_with_index.collect{|x, i| [dea_numbers[i], x, dea_expiration_times[i]]}
        provider_dea_info = dea_result.collect{|x|{ provider_dea: x[0], provider_dea_state: x[1], provider_dea_expiration_date: x[2] }}
      elsif dea_expiration_times.present?
        dea_result = dea_expiration_times.each_with_index.collect{|x, i| [dea_numbers[i], dea_states[i], x] }
        provider_dea_info = dea_result.collect{|x|{ provider_dea: x[0], provider_dea_state: x[1], provider_dea_expiration_date: x[2] }}
      end
      provider[:provider_dea_record] = provider_dea_info
      provider = provider.except(:provider_dea, :provider_dea_state, :provider_dea_expiration_date)
    end
    provider
  end

  def self.application_upload_field_validations(application)
    validation_fields = application.app_upload_fields.includes(:app_upload_field_validations).where("required =? ", 1).all
  end

  def self.validate_required_field(providers, application)
    required_field_errors, invalid_providers = [], []
    provider_keys, provider_dea_keys = [], []
    provider_validations = application_upload_field_validations(application)
    providers.each do |provider|
      if provider.present?
        provider_keys = provider.keys
        if provider[:provider_dea_record].present?
          dea_numbers = provider[:provider_dea_record]
          provider_dea_keys = dea_numbers.first.keys
        end
        provider_validations.each do |vf|
          begin
            if vf.required?
              if provider_keys.include? vf.name.to_sym
                ValidateRecord.presence_validation(provider, vf)
              end
              if provider_dea_keys.include? vf.name.to_sym
                if dea_numbers.present?
                  dea_numbers.each do |dea_number|
                    ValidateRecord.presence_validation(dea_number, vf)
                  end
                end
              end
            else
              next
            end
          rescue ValidateRecord::FieldPresenceError => e
            required_field_errors << vf.name
            invalid_providers << provider
          end
        end
      end
    end
    required_field_status = required_field_errors.present? ? false : true
    required_field_errors = required_field_errors.uniq.compact.map!{ |c| c.titleize.strip }
    [required_field_status, required_field_errors, invalid_providers]
  end

  def self.validate_provider(provider, application, upload_field_validations)
    provider_error_messages = []
    upload_field_validations.each do |f_validation|
      f_validation.app_upload_field_validations.each do |field_validation|
        validate, error_message = class_eval((field_validation.validation.classify + "Validation")).validate(provider, field_validation) rescue nil
        unless validate
          provider_error_messages << error_message
        end
      end
    end
    provider_error_messages = provider_error_messages.flatten.compact
    final_status = provider_error_messages.present? ? false : true
    [final_status, provider_error_messages.flatten.join(", ")]
  end
end
