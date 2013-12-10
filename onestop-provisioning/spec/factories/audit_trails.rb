FactoryGirl.define do
  factory :audit_trail do
    file_name "MyString"
    fk_registered_app_id 1
    file_url Faker::Internet::url
    created_date "2013-07-17 18:58:58"
    fk_cao_id 1
    fk_organization_id 1
  end
end
