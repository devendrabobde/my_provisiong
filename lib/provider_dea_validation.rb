module ProviderDeaValidation
  def self.validate(provider, vf)
   error_messages = []
   provider = provider.symbolize_keys
   dea_numbers = provider[:provider_dea_record]
    if dea_numbers.present?
      dea_numbers.each do |dea_number|
       dea_number = dea_number.symbolize_keys
        if dea_number[:provider_dea].present?
          unless validate_provider_dea(dea_number[:provider_dea])
            error_messages << VALIDATION_MESSAGE["EPCS"]["DEA_NUMBER"]["CHECKSUM_ERROR_MESSAGE"]
          end
        end
      end
    end
    error_messages = error_messages.compact.uniq
    final_status = error_messages.present? ? false : true
    [final_status, error_messages]
  end
  def self.validate_provider_dea(dea_number)
    dea = dea_number.to_s.split(//)
    # Step 1: Add together the first, third and fifth digits ["A", "b", "1", "2", "3", "4", "5", "6", "7"]
    step1_result = dea[2].to_i + dea[4].to_i + dea[6].to_i
    # Step 2: Add together the second, fourth and sixth digits and multiply the sum by 2
    step2_result = (dea[3].to_i + dea[5].to_i + dea[7].to_i) * 2
    # Step 3: Add values obtained from 1 + 2
    step3_result3 = step1_result + step2_result
    # Step 4:The rightmost digit of the value in Step 3 is used as the check digit in the DEA number
    calculated_checksum_digit = step3_result3.to_s.split(//).last.to_i
    calculated_checksum_digit == dea.last.to_i ? true : false
  end
end
