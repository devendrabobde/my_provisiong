FactoryGirl.define do
  factory :audit_trail do
    file_name "MyString"
    fk_registered_app_id 1
    total_providers 2
    file_url "mystring"
    created_date "2013-07-17 18:58:58"
    status "MyString"
    fk_cao_id 1
    fk_organization_id 1
    upload_status true
    total_npi_processed 2
  end
end
