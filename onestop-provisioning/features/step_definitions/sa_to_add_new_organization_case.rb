Given(/^a valid SA$/) do
admin = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
password: "password", password_confirmation: "password")
role = Role.create(name: "Admin")
Organization.delete_all
# organization = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address, 
# address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name, 
# contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email)
admin.update_attributes(fk_role_id: role.id)
@current_cao = admin
end

Given(/^I click on create organization$/) do
	binding.pry
	click_link "Create Organization"
end

Then(/^I should see a form$/) do
  page.should have_content("Create Organization")
  page.should have_button("Create Organization")
end

When(/^I fill in form with proper organization details and submit$/) do
  fill_in "organization_name", Faker::Company.name
  fill_in "organization_address1", Faker::Address.street_address
  fill_in "organization_address2", Faker::Address.street_address
  fill_in "organization_contact_first_name", Faker::Name.first_name
  fill_in "organization_contact_last_name", Faker::Name.last_name
  fill_in "organization_contact_email", Faker::Internet.email
  click_button "Create Organization"
end

Then(/^I should see success message and organization details$/) do
  page.should have_content("Organization was created successfully.")
  page.should have_content("Organization Details.")
end
