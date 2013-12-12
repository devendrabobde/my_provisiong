FactoryGirl.define do
  factory :provider_error_log do
    application_name "EPCS-IDP"
    error_message "MyString"
    fk_cao_id 1
    fk_audit_trail_id 1
  end
end
