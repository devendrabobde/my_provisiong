Given /^a valid COA having NPI providers already registered with the COAs organization$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
  first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
  password: "password@123", password_confirmation: "password@123")
  role = Role.create(name: "COA")
  profile = Profile.create(profile_name: Faker::Name.first_name)
  @organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization_coa.id, fk_profile_id: profile.id)
  coa.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: coa.id)
  @current_cao = coa
end