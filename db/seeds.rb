# Setup default user roles
role_list = ["Admin","COA"]
role_list.each { |name| Role.where(:name => name).first_or_create }

# Setup Super Admin account
cao = Cao.where(email: "superadmin@onestop.com").first_or_create
cao.username = "superadmin"
cao.password = "password"
cao.first_name = "super"
cao.last_name = "admin"
cao.fk_role_id = Role.where(:name => "Admin").first_or_create.id
cao.save!

# Setup default profiles
profile_list = ["Doctor","Nurse"]
profile_list.each {|profile| Profile.where(profile_name: profile).first_or_create! }

applications = ["EPCS-IDP","Backline"]
applications.each {|app| RegisteredApp.where(app_name: app).first_or_create! }

#
# Provisioning CSV Upload Validation As per Batch Upload Model
#

AppUploadField.delete_all
AppUploadFieldValidation.delete_all

## EPCS Application Validation

app_upload_fields = [
  { name: "npi", field_type: "string", required: true, field_format: "^\\d{10}$", display_name: "Provider NPI" },
  { name: "provider_dea", field_type: "string", required: true, field_format: "^[a-zA-Z]{2}+\\d{7}$", display_name: "Provider DEA" },
  { name: "provider_dea_state", field_type: "string", required: true, field_format: "^[A-Z]{2}$", display_name: "Provider DEA State"  },
  { name: "provider_dea_expiration_date", field_type: "datetime", required: true, field_format: "^([1-9]|0[1-9]|1[012])[\\/]([1-9]|0[1-9]|[12][0-9]|3[01])[\\/][0-9]{4}$", display_name: "Provider DEA Expiration Date"},
  { name: "last_name", field_type: "string", required: true, field_format: "^[a-zA-Z'-]+$", display_name: "Provider Last Name" },
  { name: "first_name", field_type: "string", required: true, field_format: "^[a-zA-Z'-]+$", display_name: "Provider First Name" },
  { name: "address_1", field_type: "text", required: true, field_format: nil, display_name: "Provider Home Address1" },
  { name: "address_2", field_type: "text", required: false, field_format: nil, display_name: "Provider Home Address2" },
  { name: "city", field_type: "string", required: true, field_format: nil, display_name: "Provider Home City" },
  { name: "state", field_type: "string", required: true, field_format: "^[A-Z]{2}$", display_name: "Provider Home State" },
  { name: "zip", field_type: "string", required: true, field_format: "^\\d{5}((-|\\s)?\\d{4})?$", display_name: "Provider Home Zip" },
  { name: "phone", field_type: "string", required: true, field_format: "^\\+?[\\d.-]+$", display_name: "Provider Work phone" },
  { name: "email", field_type: "string", required: true, field_format: "^.+@.+\\..+$", display_name: "Provider Primary Contact Email" },
  { name: "provider_otp_token_serial", field_type: "string", required: true, field_format: nil, display_name: "Provider OTP token serial #" },
  { name: "resend_flag", field_type: "string", required: false, field_format: nil, display_name: "Resend Flag" },
  { name: "hospital_admin_first_name", field_type: "string", required: true, field_format:nil, display_name: "Hospital Admin First Name" },
  { name: "hospital_admin_last_name", field_type: "string", required: true, field_format: nil, display_name: "Hospital Admin Last Name" },
  { name: "idp_performed_date", field_type: "datetime", required: true, field_format: "^([1-9]|0[1-9]|1[012])[\\/]([1-9]|0[1-9]|[12][0-9]|3[01])[\\/][0-9]{4}$", display_name: "IDP performed date" },
  { name: "idp_performed_time", field_type: "timestamp", required: true, field_format: "[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}$", display_name: "IDP performed time" },
  { name: "hospital_idp_transaction_id", field_type: "string", required: true, field_format: nil, display_name: "Hospital IDP transactionID" },
  { name: "fqdn", field_type: "string", required: false, field_format: nil, display_name: "FQDN" }
]

app_upload_fields.each do |f|
  if f.present?
    p = AppUploadField.new(f.except(:field_format))
    p.fk_registered_app_id = RegisteredApp.where( app_name: "EPCS-IDP").first_or_create.id
    p.save!
    p.app_upload_field_validations.create!([{ validation: f[:name].classify, error_message: "" }])
    if f[:field_format].present?
      p.app_upload_field_validations.create!([{ validation: "Format", error_message: "#{f[:name].classify} is not in correct format", field_format: f[:field_format] }])
    end
  end
end

## Backline Application Validation

backline_app_upload_fields = [
  { name: "npi", field_type: "string", required: false, field_format: "^\\d{10}$", display_name: "npi" },
  { name: "username", field_type: "string", required: true, field_format: "^[a-zA-Z0-9_.-]+$", display_name: "username" },
  { name: "password", field_type: "string", required: true, field_format: nil, display_name: "password"  },
  { name: "role", field_type: "string", required: true, field_format: nil, display_name: "role"},
  { name: "prefix", field_type: "string", required: false, field_format: nil, display_name: "prefix"},
  { name: "last_name", field_type: "string", required: true, field_format: "^[a-zA-Z'-]+$", display_name: "last_name" },
  { name: "first_name", field_type: "string", required: true, field_format: "^[a-zA-Z'-]+$", display_name: "first_name" },
  { name: "middle_name", field_type: "string", required: false, field_format: "^[a-zA-Z'-]+$", display_name: "middle_name" },
  { name: "suffix", field_type: "string", required: false, field_format: nil, display_name: "suffix" },
  { name: "degrees", field_type: "string", required: false, field_format: nil, display_name: "degrees" },
  { name: "birth_date", field_type: "string", required: false, field_format: nil, display_name: "birth_date" },
  { name: "email", field_type: "string", required: true, field_format: "^.+@.+\\..+$", display_name: "email" },
  { name: "address_1", field_type: "text", required: false, field_format: nil, display_name: "address_1" },
  { name: "address_2", field_type: "text", required: false, field_format: nil, display_name: "address_2" },
  { name: "city", field_type: "string", required: false, field_format: nil, display_name: "city" },
  { name: "state", field_type: "string", required: false, field_format: "^[A-Z]{2}$", display_name: "state" },
  { name: "zip", field_type: "string", required: false, field_format: "^\\d{5}((-|\\s)?\\d{4})?$", display_name: "zip" },
  { name: "postal_code", field_type: "string", required: false, field_format: nil, display_name: "postal_code" },
  { name: "phone", field_type: "string", required: true, field_format: "^\\+?[\\d.-]+$", display_name: "phone" },
  { name: "fax", field_type: "string", required: false, field_format: nil, display_name: "fax" },
  { name: "department", field_type: "string", required: true, field_format: nil, display_name: "department" }
]

backline_app_upload_fields.each do |f|
  if f.present?
    p = AppUploadField.new(f.except(:field_format))
    p.fk_registered_app_id = RegisteredApp.where( app_name: "Backline").first_or_create.id
    p.save!
    p.app_upload_field_validations.create!([{ validation: f[:name].classify, error_message: "" }])
    if f[:field_format].present?
      p.app_upload_field_validations.create!([{ validation: "Format", error_message: "#{f[:name].classify} is not in correct format", field_format: f[:field_format] }])
    end
  end
end
