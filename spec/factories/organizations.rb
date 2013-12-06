FactoryGirl.define do
  factory :organization do
    name Faker::Name.name
    address1 Faker::Address.street_address
    address2 Faker::Address.street_address
    city Faker::Address.city
    state_code Faker::Address.state
    postal_code Faker::Address.zip_code
    country_code "+52"
    contact_first_name Faker::Name.first_name
    contact_last_name Faker::Name.last_name
    contact_phone "8149185807"
    contact_fax "27892"
    contact_email Faker::Internet.email
  end
end
