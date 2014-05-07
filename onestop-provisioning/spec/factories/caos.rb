FactoryGirl.define do
  factory :cao do
   user_id Faker::Internet.slug
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    is_active false
    fk_organization_id 1
    fk_profile_id 1
    email Faker::Internet.email
    password "password@123"
    password_confirmation "password@123"
    username Faker::Internet.user_name
    fk_role_id 1
  end
end
