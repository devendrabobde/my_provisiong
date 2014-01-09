Given /^valid COA credentials$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "password", password_confirmation: "password")
  role = Role.create(name: "COA")
  @organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345", 
    postal_code: "54321", state_code: "AL123")
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization_coa.id)
  @current_cao = coa
end

When /^I select a csv file which contains single batch of multiple providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'one_single_batch_of_multiple_providers.csv') # id
end

And /^I should be able to see failure message for failed WsSetUpOrganizationStatus$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not =~ /Success/
  end
end