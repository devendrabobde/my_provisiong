class BatchUpload
  include ProvisioningOis
   @queue = :providers_queue

   # Ask resque to perform processing of CSV record
   def self.perform(providers,cao_id, application_id, audit_trail_id)
    cao = Cao.find(cao_id)
    application = RegisteredApp.find(application_id)
    audit_trail = AuditTrail.find(audit_trail_id)
    provider_app_detail_ids, total_npi_processed = save_providers(providers,cao,application,audit_trail)
    update_audit_trail(audit_trail, providers.count, provider_app_detail_ids, total_npi_processed)
  end


  # Process and add provider data in provisioning db
  def self.save_providers(providers, cao, application, audit_trail)
    begin
    provider_app_detail_ids, provider_invalid_ids = [], []
    total_npi_processed = 0
    if providers.present?
      provider_app_detail_ids, valid_providers, provider_invalid_ids = Provider.save_provider(providers, cao, application)
      providers = valid_providers
      if providers.present?
        invalid_providers, response = ProvisioningOis::batch_upload_dest(providers, cao, application)
      end
      
      # Update invalid providers status_code and status_text
      if invalid_providers.present?
        invalid_providers.each do |provider_record|
          if provider_record.present?
              provider = Provider.where("first_name like (?) and last_name like (?) and fk_provider_app_detail_id in (?)", "%#{provider_record[:first_name]}%", "%#{provider_record[:last_name]}%", provider_app_detail_ids.flatten).first
              if provider.present?
                error_msg = application.app_name + " OIS: " + provider_record[:error]
                error_code = provider_record[:status].present? ? provider_record[:status] : "500"
                provider.provider_app_detail.update_attributes(status_code: error_code, status_text: error_msg)
              end
          end
        end
      end

      # OneStop Router Response
      if response.present?
        if response["invalid_users"].present?
          response["invalid_users"].each do |record|
            record.each do |key,val|
              provider_fullname = key.strip.split(" ")
              provider = Provider.where("first_name like (?) and last_name like (?) and fk_provider_app_detail_id in (?)", "%#{provider_fullname.first}%", "%#{provider_fullname.last}%", provider_app_detail_ids.flatten).first
              if provider.present?
                error_msg = "Bad Request: " + val.to_s
                provider.provider_app_detail.update_attributes(status_code: 500,status_text: error_msg)
              end
            end
          end
        else
          if response[:error].present?
            provider_app_details = ProviderAppDetail.find_provider_app_details(provider_app_detail_ids - provider_invalid_ids)
            provider_app_details.update_all(status_code: 503, status_text: "Connection Error")
          end
        end
        if response["valid_users"].present?
          response["valid_users"].each do |record|
            provider_fullname = record.strip.split(" ")
            provider = Provider.where("first_name like (?) and last_name like (?) and fk_provider_app_detail_id in (?)", "%#{provider_fullname.first}%", "%#{provider_fullname.last}%", provider_app_detail_ids.flatten).first
            if provider.present?
              provider.provider_app_detail.update_attributes(status_code: 200, status_text: "Success")
              total_npi_processed = total_npi_processed + 1
            end
          end
        end
        if response["errors"].present?
          error_res = response["errors"].first
          provider_app_details = ProviderAppDetail.find_provider_app_details(provider_app_detail_ids - provider_invalid_ids)
          provider_app_details.update_all(status_code: error_res["code"], status_text: error_res["message"])
        end
      end
    end
    rescue => e
      ProviderErrorLog.create( application_name: "OneStop Provisioning System", error_message: "Resque backgroud job fail: " + e.message, fk_audit_trail_id: audit_trail.id)
      audit_trail.update_attributes(status: "1", upload_status: true, total_providers: providers.count)
      Rails.logger.error e
    end
    [provider_app_detail_ids, total_npi_processed]
  end

  #
  # After processiong csv file, update the file upload status with total NPI processed count
  #
  def self.update_audit_trail(audit_trail, total_provider_count, provider_app_detail_ids, total_npi_processed)
    provider_app_details = ProviderAppDetail.find_provider_app_details(provider_app_detail_ids.flatten)
    provider_app_details.update_all(fk_audit_trail_id: audit_trail.id)
    audit_trail.update_attributes( total_providers: total_provider_count, upload_status: true, total_npi_processed: total_npi_processed)
  end
end
