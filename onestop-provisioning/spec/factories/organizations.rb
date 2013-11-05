FactoryGirl.define do
  factory :organization do
    name Faker::Name.name
    address1 "MyString"
    address2 "MyString"
    city Faker::Address.city
    state_code "1264"
    postal_code "12356"
    country_code "091"
    contact_first_name Faker::Name.first_name
    contact_last_name Faker::Name.last_name
    contact_phone "154214"
    contact_fax "5846125"
    contact_email Faker::Internet.email
    idp_vendor_id 1
  end
end
