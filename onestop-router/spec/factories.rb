FactoryGirl.define do
  factory :organization do
    organization_name  { Faker::Company.name }
    contact_first_name { Faker::Name.first_name }
    contact_last_name  { Faker::Name.last_name }
    organization_npi   { "#{1_000_000_000 + Organization.count}" }
  end

  factory :ois_client do
    ois_client_preference
    client_password  { Password.new }
    client_name      { Faker::Name.name }
  end

  factory :ois do
    ois_name                  { Faker::Name.title }
    ois_password              { Password.new }
    outgoing_service_id       { Faker::Lorem.characters(25) }
    outgoing_service_password { Faker::Lorem.characters(25) }
    enrollment_url            { Faker::Internet.url }
    authentication_url        { Faker::Internet.url }
    organization
    disabled                  false
    idp_level                 3
  end

  factory :ois_client_preference do
    preference_name    { "#{Faker::Name.name} Preferences" }
    faq_url            { Faker::Internet.url }
    help_url           { Faker::Internet.url }
    logo_url           { Faker::Internet.url }
  end

  factory :default_ois_client_preference, :parent => :ois_client_preference do
    preference_name "OneStop Default"
    slug            OisClientPreference::DEFAULT_SLUG
    client_name     "OneStop"
    faq_url         "http://www.drfirst.com/onestop/faq"
    help_url        "http://www.drfirst.com/onestop/help"
    logo_url        "http://www.drfirst.com/onestop/logo.png"
  end

  factory :user do
    npi          { "#{1_000_000_000 + User.count}" }
    first_name   { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
  end

  factory :ois_user_token do
    ois
    user
  end

  factory :admin_user do
    user_name { Faker::Internet.user_name }
    email     { Faker::Internet.email }
    password  "password"
  end
end
