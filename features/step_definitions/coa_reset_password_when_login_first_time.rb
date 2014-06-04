Given(/^a valid COA associated with "(.*?)"$/) do |organization_name|
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
                   first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
                   password: "password@123", password_confirmation: "password@123")
  role              = Role.create(name: "COA")
  profile           = Profile.create(profile_name: Faker::Name.first_name)
  @organization_coa = Organization.find_by_name(organization_name)
  if @organization_coa.blank?
    @organization_coa = Organization.create(name: organization_name, address1: Faker::Address.street_address,
                                          address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
                                          contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
  end
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization_coa.id, fk_profile_id: profile.id)
  @current_cao = coa
end

Given /^a valid COA details$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
                   first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
                   password: "password@123", password_confirmation: "password@123")
  role              = Role.create(name: "COA")
  profile           = Profile.create(profile_name: Faker::Name.first_name)
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

And /^I click on update without entering required fields$/ do
  click_button("Update")
end

Then /^I should see error message as This field is required$/ do
  page.should have_content("This field is required.")
end

And /^I fill in system unexpected password in new password field$/ do
  fill_in('cao_password', with: 'p')
end

Then /^I should see error message as Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character$/ do
  page.should have_content("Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character")
end

And /^I fill in dissimilar value in password confirmation field$/ do
  fill_in('cao_password', with: 'password@12345')
  fill_in('cao_password_confirmation', with: 'password')
end

Then /^I should see error message as Please enter the same value again$/ do
  page.should have_content("Please enter the same value again.")
end

And(/^I click on update with the new password and correct old password$/) do
  fill_in('cao_current_password', with: 'password@123')
  fill_in('cao_password', with: 'Password@12345')
  fill_in('cao_password_confirmation', with: 'Password@12345')
  select "What was your childhood nickname?", from: "cao_security_question"
  fill_in "cao_security_answer", with: "scott"
  click_button("Update")
end

Then(/^I should see success message as You updated your account successfully$/) do
  page.should have_content("You updated your account successfully.")
end

And /^I click on update with the new password which I had used in past$/ do
  fill_in('cao_current_password', with: 'password@123')
  fill_in('cao_password', with: 'password@123')
  fill_in('cao_password_confirmation', with: 'password@123')
  select "What was your childhood nickname?", from: "cao_security_question"
  fill_in "cao_security_answer", with: "scott"
  click_button("Update")
end

Then /^I should see error message as Password was already taken in the past$/ do
  page.should have_content("Password was already taken in the past! ")
end

And /^I click on update with incorrect old password$/ do
  fill_in('cao_current_password', with: 'password')
  fill_in('cao_password', with: 'Password@12345')
  fill_in('cao_password_confirmation', with: 'Password@12345')
  select "What was your childhood nickname?", from: "cao_security_question"
  fill_in "cao_security_answer", with: "scott"
  click_button("Update")
end

Then /^I should see error message as Current password is invalid$/ do
  page.should have_content("Current password is invalid")
end
