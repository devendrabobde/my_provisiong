class Provider < ActiveRecord::Base
  require 'csv'
  include Extensions::UUID
  include ProvisioingCsvValidation

  attr_accessible :username, :password, :role, :prefix, :first_name, :middle_name,
    :last_name, :suffix, :degrees, :npi, :birth_date, :email, :address_1, :address_2,
    :city, :state, :postal_code, :phone, :fax, :department, :provider_otp_token_serial,
    :resend_flag, :hospital_admin_first_name, :hospital_admin_last_name, :idp_performed_date,
    :idp_performed_time, :hospital_idp_transaction_id, :fk_provider_app_detail_id, :zip, :fqdn,
    :gender, :social_security_number,:use_existing_account, :member_type, :practice_group,
    :medical_license_number, :medical_license_state, :specialty, :secondary_license, :external_id_1, :external_id_2, :practice_external_id, :default_location_external_id,
    :display_name, :user_type, :resident, :security_question, :security_answer, :phone_extension,
    :fax_extension, :country, :office_address_line_1, :office_address_line_2, :office_address_city,
    :office_address_state, :office_address_country, :office_address_zip

  alias_attribute :sys_provider_id, :id

  #
  # Associations
  #

  has_many :provider_error_logs, foreign_key: :fk_provider_id
  belongs_to :provider_app_detail, foreign_key: :fk_provider_app_detail_id

  #
  # class methods
  #

  #
  # Save provider record to provision db and process the same
  #
  def self.save_provider(providers, cao, application, app_hash_router)
    valid_providers, providers_ids, provider_invalid_ids = [], [], []

    t1 = Time.now
    validated_providers = ProvisioingCsvValidation::validate_provider_api(providers, application, app_hash_router)
    Rails.logger.info "Benchmarking - validate_provider_api  - elapsed time:#{Time.now - t1} sec"
    if validated_providers.present?
      validated_providers.each do |provider|
        if provider.present?
          provider = provider.symbolize_keys
          provider_app_detail = application.provider_app_details.create(fk_cao_id: cao.id, fk_organization_id: cao.organization.id)
          if provider_app_detail.present?
            providers_ids << provider_app_detail.id
            provider_app_detail.create_provider(provider.except(:provider_dea_record, :validation_error_message, :status))
            provider_deas = provider[:provider_dea_record]
            if provider_deas.present?
              provider_deas.each do |dea|
                if dea.present?
                  provider_app_detail.provider_dea_numbers.create(dea)
                end
              end
            end
            unless provider[:validation_error_message].present?
              provider[:sys_provider_app_detail_id] = provider_app_detail.id
              valid_providers << provider
            else
              # update status code and message
              error_code = provider[:status].present? ? provider[:status] : "422"
              provider_invalid_ids << provider_app_detail.id
              provider_app_detail.update_attributes(status_code: error_code, status_text: provider[:validation_error_message].gsub(/^\,/, ""))
            end
          end
        end
      end # do loop end
    end
    [providers_ids, valid_providers, provider_invalid_ids]
  end


  #
  # used to download provider csv file based on application conditions
  #
  def self.to_csv(application, options = {})
    if application.app_name.eql?(CONSTANT["APP_NAME"]["EPCS"])
      csv_cols = ["Provider NPI", "Provider DEA", "Provider DEA State", "Provider DEA Expiration Date",
        "Provider Last Name", "Provider First Name", "Provider Home Address1", "Provider Home Address2",
        "Provider Home City","Provider Home State", "Provider Home Zip", "Provider Work phone",
        "Provider Primary Contact Email", "Provider OTP token serial #", "Resend Flag", "Hospital Admin First Name",
        "Hospital Admin Last Name", "IDP performed date", "IDP performed time", "Hospital IDP transactionID", "Provider Middle Name", "Provider Prefix", "Provider Gender", "Provider Dateofbirth", "Provider SocialSecurityNumber"]
      CSV.generate(options) do |csv|
        csv << csv_cols
        all.each do |provider|
          provider_dea_nums = provider.provider_app_detail.provider_dea_numbers
          csv << [ provider.npi, provider_dea_nums.pluck(:provider_dea).join("~"), provider_dea_nums.pluck(:provider_dea_state).join("~"), provider_dea_nums.collect{|x| x.provider_dea_expiration_date.try(:strftime, '%d/%m/%Y')}.delete_if{|x| x.nil? }.join("~"),
            provider.last_name, provider.first_name, provider.address_1, provider.address_2, provider.city, provider.state,
            provider.zip, provider.phone, provider.email, provider.provider_otp_token_serial, provider.resend_flag,
            provider.hospital_admin_first_name, provider.hospital_admin_last_name, provider.idp_performed_date,
            provider.idp_performed_time.try(:strftime, "%H:%M:%S"), provider.hospital_idp_transaction_id, provider.middle_name, provider.prefix, provider.gender, provider.birth_date.try(:strftime, '%d/%m/%Y'), provider.social_security_number ]
        end
      end
    elsif application.app_name.eql?(CONSTANT["APP_NAME"]["BACKLINE"])
      remove_columns = ["id","created_at","updated_at","provider_app_detail_id", "provider_otp_token_serial",
        "resend_flag", "hospital_admin_first_name", "hospital_admin_last_name", "idp_performed_date",
        "idp_performed_time", "hospital_idp_transaction_id", "zip"]
      CSV.generate(options) do |csv|
        csv << column_names - remove_columns
        all.each do |product|
          csv << product.attributes.values_at(*column_names - remove_columns)
        end
      end
    elsif application.app_name.eql?(CONSTANT["APP_NAME"]["RCOPIA"])
      remove_columns = []
      CSV.generate(options) do |csv|
        csv << column_names - remove_columns
        all.each do |product|
          csv << product.attributes.values_at(*column_names - remove_columns)
        end
      end
    end
  end
end
