Given /^a valid COA details$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "password@123", password_confirmation: "password@123")
  role = Role.create(name: "COA")
  profile = Profile.create(profile_name: Faker::Name.first_name)
  @organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization_coa.id, fk_profile_id: profile.id)
  @current_cao = coa
end

When /^I go to signin page$/ do
  visit new_cao_session_path
end

And /^I fill in username and password$/ do
  fill_in "cao_username", with: @current_cao.username
  fill_in "cao_password", with: "password@123"
end

And /^I click "Sign in"$/ do
  click_button "LOG IN"
end

Given /^I visit application page$/ do
  visit application_admin_providers_path
end

Then(/^I should be able to see Change Password form$/) do
  page.should have_content("Change Password")
end

And(/^I click on update with the new password and correct old password$/) do
  fill_in('cao_current_password', :with => 'password@123')
  fill_in('cao_password', :with => 'password@12345')
  fill_in('cao_password_confirmation', :with => 'password@12345')
  click_button("Update")  
end

Then(/^I should see success message as You updated your account successfully$/) do
  page.should have_content("You updated your account successfully.")
end