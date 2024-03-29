class BatchUpload

  # include Resque::Plugins::Status
  include ProvisioningOis
  @queue = :providers_queue

  # Custom On Failure Callback for Queue exit.
  def self.on_failure(e, *args)
      ActiveRecord::Base.connection.reconnect!
      ProviderErrorLog.create( application_name: "OneStop Provisioning System", error_message: "Resque backgroud job fail: " + e.message, fk_audit_trail_id: args[3])
      audit_trail = AuditTrail.where(upload_status: false)
      audit_trail.update_all(status: "1", upload_status: true, total_providers: args[0].count) rescue nil
      Rails.logger.error e
  end
  
   # Ask resque to perform processing of CSV record
  def self.perform(providers,cao_id, application_id, audit_trail_id, app_hash_router)
    begin
      cao = Cao.find(cao_id)
      application = RegisteredApp.find(application_id)
      audit_trail = AuditTrail.find(audit_trail_id)
      provider_app_detail_ids, total_npi_processed = save_providers(providers,cao,application,audit_trail,app_hash_router) 
      provider_app_details = ProviderAppDetail.find_provider_app_details(provider_app_detail_ids.flatten)
      provider_app_details.update_all(fk_audit_trail_id: audit_trail.id)
      audit_trail.update_attributes(total_providers: providers.count, upload_status: true, total_npi_processed: total_npi_processed)
    rescue Exception => e
      audit_trail = AuditTrail.find(audit_trail_id)
      ProviderErrorLog.create( application_name: "OneStop Provisioning System", error_message: "Resque backgroud job fail: " + e.message, fk_audit_trail_id: audit_trail.id)
      audit_trail.update_attributes(status: "1", upload_status: true, total_providers: providers.count)
      Rails.logger.error e
    end
  end


  # Process and add provider data in provisioning db
  def self.save_providers(providers, cao, application, audit_trail, app_hash_router) 
    provider_app_detail_ids, provider_invalid_ids, provi_invalid_ids  = [], [], []
    total_npi_processed = 0
    if providers.present?
      provider_app_detail_ids, valid_providers, provider_invalid_ids = Provider.save_provider(providers, cao, application, app_hash_router)
      providers = valid_providers
      if providers.present?
        invalid_providers, npiless_providers, response = ProvisioningOis::batch_upload_dest(providers, cao, application, app_hash_router) 
      end
      
      # Update invalid providers status_code and status_text
      if invalid_providers.present?
        invalid_providers.each do |provider_record|
          if provider_record.present?
              provider_app_detail = ProviderAppDetail.where(sys_provider_app_detail_id: provider_record[:sys_provider_app_detail_id]).first
              if provider_app_detail.present?
                error_msg = application.app_name + " OIS: " + provider_record[:error]
                error_code = provider_record[:status].present? ? provider_record[:status] : "500"
                provi_invalid_ids << provider_app_detail.id
                provider_app_detail.update_attributes(status_code: error_code, status_text: error_msg)
              end
            end
          end
        end

      # OneStop Router Response
      if response.present?
        if response[:error].present?
          provider_app_details = ProviderAppDetail.find_provider_app_details(provider_app_detail_ids - provider_invalid_ids)
          provider_app_details.update_all(status_code: 503, status_text: "Connection Error - unable to connect Onestop Router")
        end
        if response["providers"].present?
          response["providers"].each do |provider|
            provider = provider.symbolize_keys
            provider_app_detail = ProviderAppDetail.where(sys_provider_app_detail_id: provider[:sys_provider_app_detail_id]).first
            if provider_app_detail.present?
              provider_app_detail.update_attributes(status_code: provider[:status], status_text: provider[:status_text])
              total_npi_processed = total_npi_processed + 1 if provider[:status].to_i == 200
            end
          end
        end
        if response["errors"].present?
            error_res = response["errors"].first
            provider_app_details = ProviderAppDetail.find_provider_app_details(provider_app_detail_ids - provider_invalid_ids)
            provider_app_details.update_all(status_code: error_res["code"], status_text: error_res["message"])
        end
      end

      # Handle providers without npi number
      if npiless_providers.present?
        npiless_providers.each do |provider_record|
          if provider_record.present?
            provider_app_detail = ProviderAppDetail.where(sys_provider_app_detail_id: provider_record[:sys_provider_app_detail_id]).first
            status_text = "Succesfully authenticated provider without NPI " +  application.app_name
            provider_app_detail.update_attributes(status_code: 200, status_text: status_text )
            total_npi_processed = total_npi_processed + 1
          end
        end
      end
    end
    [provider_app_detail_ids, total_npi_processed]
  end
end
