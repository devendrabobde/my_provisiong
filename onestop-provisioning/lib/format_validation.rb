#
# This class is basically used to validate provider record field format with Regular Expression
#
module FormatValidation
  def self.validate(provider, field_validation)
   provider_record = provider.symbolize_keys
    check_provider_field_format(provider_record, field_validation)
  end

  def self.check_provider_field_format(provider_record, field_validation)
   error_messages = []
   provider_keys = provider_record.keys
   field_name  = field_validation.app_upload_field.name.to_sym
   if provider_keys.include? field_name
     if provider_record[field_name].present?
       unless provider_record[field_name].match Regexp.new(field_validation.field_format)
         error_messages << field_validation.error_message
       end
     end
    end
    dea_numbers = provider_record[:provider_dea_record]
    if dea_numbers.present?
      provider_dea_keys = dea_numbers.first.symbolize_keys.keys
      dea_numbers.each do |dea_number|
       dea_number = dea_number.symbolize_keys
        if provider_dea_keys.include? field_name
          if dea_number[field_name].present?
            unless dea_number[field_name].match Regexp.new(field_validation.field_format)
              error_messages << field_validation.error_message
            end
          end
        end
      end
    end
    error_messages = error_messages.uniq.compact
    format_validation_status = error_messages.present? ? false : true
    [format_validation_status, error_messages]
  end
end
