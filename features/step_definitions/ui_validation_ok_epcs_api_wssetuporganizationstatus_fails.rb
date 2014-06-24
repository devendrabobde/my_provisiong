Given /^valid COA credentials$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "password@123", password_confirmation: "password@123")
  role = Role.create(name: "COA")
  profile = Profile.create(profile_name: Faker::Name.first_name)
  @organization_coa_valid = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345", 
    state_code: "AL123")
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization_coa_valid.id, fk_profile_id: profile.id)
  coa.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: coa.id)
  @current_valid_cao = coa
end

When /^I select a csv file which contains single batch of multiple providers$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'one_single_batch_of_multiple_providers.csv') # id
end

And /^I should be able to see failure message for failed WsSetUpOrganizationStatus$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not =~ /Success/
  end
end

And /^I fill in the username and password with valid credentials$/ do
  fill_in "cao_username", with: @current_valid_cao.username
  fill_in "cao_password", with: "password@123"
end


And /^I should be able to associate provider with COA with valid credentials$/ do
  ProviderAppDetail.where(fk_cao_id: @current_valid_cao.id).count > 0
end