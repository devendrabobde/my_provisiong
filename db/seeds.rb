# Setup default user roles
role_list = ["Admin","COA"]
role_list.each { |name| Role.where(:name => name).first_or_create }

# Setup Super Admin account
cao = Cao.where(email: "superadmin@onestop.com").first_or_create
cao.username = "superadmin"
if cao.new_record?
  cao.password = "password@1234"
end
cao.first_name = "super"
cao.last_name = "admin"
cao.fk_role_id = Role.where(:name => "Admin").first_or_create.id
cao.save!

# Setup default profiles
profile_list = ["Doctor","Nurse"]
profile_list.each {|profile| Profile.where(profile_name: profile).first_or_create! }


RegisteredApp.delete_all


## The display_name column should have the name of Organization and name of OIS from Router concatenated by a '-'
applications = [{ app_name: "EPCS-IDP", display_name: "DrFirst-epcsidp"},
                { app_name: "Rcopia", display_name: "DrFirst-rcopia"},
                { app_name: "Moxy", display_name: "DrFirst-moxy"},
                { app_name: "Backline", display_name: nil }]


applications.each do |app|
  RegisteredApp.where(app_name: app[:app_name], display_name: app[:display_name]).first_or_create!
end

# applications = ["EPCS-IDP","Backline", "Rcopia", "moxy"]
# applications.each {|app| RegisteredApp.where(app_name: app).first_or_create! }

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
  { name: "email", field_type: "string", required: true, field_format: "^.+@.+\\..+$", display_name: "Provider Primary Contact Email" },
  { name: "provider_otp_token_serial", field_type: "string", required: true, field_format: nil, display_name: "Provider OTP token serial #" },
  { name: "resend_flag", field_type: "string", required: false, field_format: nil, display_name: "Resend Flag" },
  { name: "hospital_admin_first_name", field_type: "string", required: true, field_format:nil, display_name: "Hospital Admin First Name" },
  { name: "hospital_admin_last_name", field_type: "string", required: true, field_format: nil, display_name: "Hospital Admin Last Name" },
  { name: "idp_performed_date", field_type: "datetime", required: true, field_format: "^([1-9]|0[1-9]|1[012])[\\/]([1-9]|0[1-9]|[12][0-9]|3[01])[\\/][0-9]{4}$", display_name: "IDP performed date" },
  { name: "idp_performed_time", field_type: "timestamp", required: true, field_format: "[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}$", display_name: "IDP performed time" },
  { name: "hospital_idp_transaction_id", field_type: "string", required: false, field_format: nil, display_name: "Hospital IDP transactionID" },
  { name: "fqdn", field_type: "string", required: false, field_format: nil, display_name: "FQDN" },
  { name: "middle_name", field_type: "string", required: false, field_format: nil, display_name: "Provider Middle Name" },
  { name: "prefix", field_type: "string", required: false, field_format: nil, display_name: "Provider Prefix" },
  { name: "gender", field_type: "string", required: true, field_format: "^[M|F]$", display_name: "Provider Gender" },
  { name: "birth_date", field_type: "string", required: true, field_format: "^([1-9]|0[1-9]|1[012])[\\/]([1-9]|0[1-9]|[12][0-9]|3[01])[\\/][0-9]{4}$", display_name: "Provider Dateofbirth" },
  { name: "social_security_number", field_type: "string", required: false, field_format: nil, display_name: "Provider SocialSecurityNumber" }
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

## Rcopia Application Validation

rcopia_app_upload_fields = [
  { name: "npi", field_type: "string", required: false, field_format: "^\\d{10}$", display_name: "National Provider Identifier" },
  { name: "username", field_type: "string", required: false, field_format: "^[a-zA-Z0-9_.-]+$", display_name: "Preferred Rcopia Username" },
  { name: "role", field_type: "string", required: true, field_format: nil, display_name: "Rcopia Roles"},
  { name: "prefix", field_type: "string", required: false, field_format: nil, display_name: "Prefix"},
  { name: "last_name", field_type: "string", required: false, field_format: "^[a-zA-Z'-]+$", display_name: "LAST NAME" },
  { name: "first_name", field_type: "string", required: false, field_format: "^[a-zA-Z'-]+$", display_name: "FIRST NAME" },
  { name: "middle_name", field_type: "string", required: false, field_format: "^[a-zA-Z'-]+$", display_name: "MIDDLE NAME" },
  { name: "suffix", field_type: "string", required: false, field_format: nil, display_name: "SUFFIX" },
  { name: "use_existing_account", field_type: "string", required: false, field_format: "^[y||n]$", display_name: "Use Existing Account" },
  { name: "member_type", field_type: "string", required: true, field_format: nil, display_name: "Member Type" },
  { name: "email", field_type: "string", required: false, field_format: "^.+@.+\\..+$", display_name: "E-MAIL ADDRESS" },
  { name: "practice_group", field_type: "string", required: false, field_format: nil, display_name: "Practice Group / Location External IDs" },
  { name: "medical_license_number", field_type: "string", required: false, field_format: nil, display_name: "Med LIC #" },
  { name: "medical_license_state", field_type: "string", required: true, field_format: "^[A-Z]{2}$", display_name: "Med Lic State" },
  { name: "specialty", field_type: "string", required: true, field_format: "^[a-zA-Z0-9_.-]+$", display_name: "SPECIALTY 1" },
  { name: "secondary_license", field_type: "string", required: false, field_format: nil, display_name: "Secondary License" },
  { name: "external_id_1", field_type: "string", required: false, field_format: nil, display_name: "External ID 1" },
  { name: "external_id_2", field_type: "string", required: false, field_format: nil, display_name: "External ID 2" },
  { name: "provider_dea", field_type: "string", required: false, field_format: "^[a-zA-Z]{2}+\\d{7}$", display_name: "DEA #" }
]

rcopia_app_upload_fields.each do |f|
  if f.present?
    p = AppUploadField.new(f.except(:field_format))
    p.fk_registered_app_id = RegisteredApp.where( app_name: "Rcopia").first_or_create.id
    p.save!
    p.app_upload_field_validations.create!([{ validation: f[:name].classify, error_message: "" }])
    if f[:field_format].present?
      p.app_upload_field_validations.create!([{ validation: "Format", error_message: "#{f[:name].classify} is not in correct format", field_format: f[:field_format] }])
    end
  end
end

## MOXY Application Validation

moxy_app_upload_fields = [
  { name: "username", field_type: "string", required: true, field_format: "^[a-zA-Z0-9_.-]+$", display_name: "Username" },
  { name: "password", field_type: "string", required: true, field_format: nil, display_name: "Password" },
  { name: "display_name", field_type: "string", required: false, field_format: nil, display_name: "Display Name" },
  { name: "prefix", field_type: "string", required: false, field_format: nil, display_name: "Prefix" },
  { name: "last_name", field_type: "string", required: true, field_format: "^[a-zA-Z'-]+$", display_name: "Last Name" },
  { name: "first_name", field_type: "string", required: true, field_format: "^[a-zA-Z'-]+$", display_name: "First Name" },
  { name: "middle_name", field_type: "string", required: false, field_format: "^[a-zA-Z'-]+$", display_name: "Middle Name" },
  { name: "suffix", field_type: "string", required: false, field_format: nil, display_name: "Suffix" },
  { name: "gender", field_type: "string", required: true, field_format: "^[O|M|F|U]$", display_name: "Gender" },
  { name: "user_type", field_type: "string", required: false, field_format: "\\b(Staff|Provider|Patient|Academic)\\b", display_name: "User Type" },
  { name: "npi", field_type: "string", required: false, field_format: "^\\d{10}$", display_name: "NPI" },
  { name: "degrees", field_type: "string", required: false, field_format: nil, display_name: "Degree" },
  { name: "resident", field_type: "string", required: true, field_format: nil, display_name: "Resident"},
  { name: "security_question", field_type: "string", required: false, field_format: nil, display_name: "Security Question"},
  { name: "security_answer", field_type: "string", required: false, field_format: nil, display_name: "Security Answer"},
  { name: "email", field_type: "string", required: true, field_format: "^.+@.+\\..+$", display_name: "Email" },
  { name: "phone", field_type: "string", required: true, field_format: "^\\+?[\\d.-]+$", display_name: "Phone Number" },
  { name: "phone_extension", field_type: "string", required: false, field_format: nil, display_name: "Phone Extension"},
  { name: "fax", field_type: "string", required: false, field_format: nil, display_name: "Fax Number" },
  { name: "fax_extension", field_type: "string", required: false, field_format: nil, display_name: "Fax Extension"},
  { name: "address_1", field_type: "text", required: false, field_format: nil, display_name: "Home Address Line 1" },
  { name: "address_2", field_type: "text", required: false, field_format: nil, display_name: "Home Address Line 2" },
  { name: "city", field_type: "string", required: false, field_format: nil, display_name: "Home Address City" },
  { name: "state", field_type: "string", required: false, field_format: "^[A-Z]{2}$", display_name: "Home Address State" },
  { name: "country", field_type: "string", required: false, field_format: "^[A-Z]{2}$", display_name: "Home Address Country" },
  { name: "zip", field_type: "string", required: false, field_format: "^\\d{5}((-|\\s)?\\d{4})?$", display_name: "Home Address Zip" },
  { name: "office_address_line_1", field_type: "text", required: false, field_format: nil, display_name: "Office Address Line 1" },
  { name: "office_address_line_2", field_type: "text", required: false, field_format: nil, display_name: "Office Address Line 2" },
  { name: "office_address_city", field_type: "string", required: false, field_format: nil, display_name: "Office Address City" },
  { name: "office_address_state", field_type: "string", required: false, field_format: "^[A-Z]{2}$", display_name: "Office Address State" },
  { name: "office_address_country", field_type: "string", required: false, field_format: "^[A-Z]{2}$", display_name: "Office Address Country" },
  { name: "office_address_zip", field_type: "string", required: false, field_format: "^\\d{5}((-|\\s)?\\d{4})?$", display_name: "Office Address Zip" }
]

moxy_app_upload_fields.each do |f|
  if f.present?
    p = AppUploadField.new(f.except(:field_format))
    p.fk_registered_app_id = RegisteredApp.where( app_name: "Moxy").first_or_create.id
    p.save!
    p.app_upload_field_validations.create!([{ validation: f[:name].classify, error_message: "" }])
    if f[:field_format].present?
      p.app_upload_field_validations.create!([{ validation: "Format", error_message: "#{f[:name].classify} is not in correct format", field_format: f[:field_format] }])
    end
  end
end