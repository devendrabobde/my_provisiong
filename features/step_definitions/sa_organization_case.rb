Given(/^a valid SA$/) do
  role = Role.create(:name => "Admin")
  role_cao = Role.create(name: "COA")
  admin = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
  first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
  password: "password@123", password_confirmation: "password@123", fk_role_id: role.id)
  @current_admin = admin
  Organization.unscoped.delete_all
  @organization = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
  address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
  contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
  @e_org_cao = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
  first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
  password: "password@123", password_confirmation: "password@123", fk_role_id: role_cao.id, fk_organization_id: @organization.id)
end

Given(/^I go to admin home page$/) do
  visit application_admin_providers_path
end

And(/^I fill in the username and password for SA$/) do
  fill_in "cao_username", with: @current_admin.username
  fill_in "cao_password", with: "password@123"
end

And(/^I click on create organization$/) do
	click_link "Create Organization"
end

Then(/^I should see a form$/) do
  page.should have_content("Create Organization")
  page.should have_button("Create Organization")
end

When(/^I fill in form with proper organization details and submit$/) do
  fill_in "organization_name", with: Faker::Company.name
  fill_in "organization_address1", with: Faker::Address.street_address
  fill_in "organization_address2", with: Faker::Address.street_address
  fill_in "organization_city", with: Faker::Address.city
  fill_in "organization_contact_first_name", with: Faker::Name.first_name
  fill_in "organization_contact_last_name", with: Faker::Name.last_name
  fill_in "organization_contact_email", with: Faker::Internet.email
  fill_in "organization_zip_code", with: "12345"
  # fill_in "organization_postal_code", with: "54321"
  select "Alabama", from: 'organization_state_code'
  click_button "Create Organization"
end

Then(/^I should see success message and organization details$/) do
  page.should have_content("Organization was created successfully.")
  page.should have_content("Organization Details")
end


Then(/^I should see a list of all organizations$/) do
  page.should have_selector('table#cao_table')
  page.should have_content("Organization Name")
  page.should have_content("Number of COAs")
  page.should have_content("Status")
  page.should have_content("Action")
  page.should have_content("COA Account")
  page.should have_content(@organization.name)
end


When(/^I click edit for an organization$/) do
  page.find(:css, 'table#cao_table tbody tr:last-child').click_link('Edit')
end

Then(/^I should see edit organization form$/) do
  page.should have_content("Edit Organization")
  page.should have_button("Update Organization")
  page.should have_selector(:css, "#organization_name")
end

When(/^I make changes and update the organization$/) do
  @o_name = Faker::Company.name
  @o_addr = Faker::Address.street_address
  @o_addr2 = Faker::Address.street_address
  @o_city = Faker::Address.city
  @o_fname = Faker::Name.first_name
  @o_lname = Faker::Name.last_name
  @o_email = Faker::Internet.email
  fill_in "organization_name", with: @o_name
  fill_in "organization_address1", with: @o_addr
  fill_in "organization_address2", with: @o_addr2
  fill_in "organization_city", with: @o_city
  fill_in "organization_contact_first_name", with: @o_fname
  fill_in "organization_contact_last_name", with: @o_lname
  fill_in "organization_contact_email", with: @o_email
  click_button "Update Organization"
end

Then(/^I should see success message for organization update and organization details$/) do
  # page.should have_content("Organization was updated successfully.")
  # page.should have_content("Organization Details")
  page.should have_content(@o_name)
  page.should have_content(@o_addr)
  page.should have_content(@o_addr2)
  page.should have_content(@o_city)
  page.should have_content(@o_fname)
  page.should have_content(@o_lname)
  page.should have_content(@o_email)
end

And(/^I should be able to view COAs of any organization$/) do
  page.find('table#cao_table tbody tr', text: @organization.name).click_link('Manage')
  page.should have_content("Listing COAs for #{@organization.name}")
  page.should have_content(@e_org_cao.first_name)
  page.should have_content(@e_org_cao.last_name)
  page.should have_content(@e_org_cao.username)
  page.should have_content(@e_org_cao.email)
end

And(/^I should be able to view all applications of selected organization$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be able to delete an organization$/) do
  page.find('table#cao_table tbody tr', text: @organization.name).click_link('Deactivate')
  click_button("Deactivate")
  page.find('table#cao_table tbody tr', text: @organization.name).should have_link("Activate")
  page.find('table#cao_table tbody tr', text: @organization.name).should have_content("Inactive")
  page.find('table#cao_table tbody tr', text: @organization.name).should_not have_link("Manage")
end

Then(/^I should be able to activate an organization which is inactive$/) do
  # @organization.update_attribute(:deleted_at, Time.now)
  # @organization.caos.update_all(deleted_at: Time.now)
  # visit application_admin_providers_path
  # page.find('table#cao_table tbody tr', text: @organization.name).click_link('Activate')
  # click_button("Activate")
  # page.find('table#cao_table tbody tr', text: @organization.name).should have_content("Active")
  # page.find('table#cao_table tbody tr', text: @organization.name).should have_link("Manage")
end
