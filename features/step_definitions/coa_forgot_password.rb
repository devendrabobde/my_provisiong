Given /^I go to application home page$/ do
  visit new_cao_session_path
end

Then /^I should be able to see forgot password link$/ do
  page.should have_content("Forgot your password?")
end

And /^I should be able to click on forgot password link$/ do
  click_link "Forgot your password?"
end

When /^I enter email on the reset password form$/ do
  @coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "password", password_confirmation: "password")
  role = Role.create(name: "COA")
  organization = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address, 
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name, 
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email)
  @coa.update_attributes(fk_role_id: role.id, fk_organization_id: organization.id)
  fill_in "cao_email", with: @coa.email
end

And /^I press Send me reset password instructions button$/ do
  click_button "Send me reset password instructions"
end

Then /^I sould be able to see You will receive an email with instructions about how to reset your password in a few minutes.$/ do
  page.should have_content("You will receive an email with instructions about how to reset your password in a few minutes.")
end

And /^I should receive email with forget password instructions$/ do
  unread_emails_for(@coa.email).size.should >= parse_email_count(1)
end

When /^I open email then I should be able to see Change my password link$/ do
  email = open_email(@coa.email)
  email.should have_body_text(/Change my password/)
end

And /^I follow Change my password link in the email$/ do
  click_first_link_in_email
end

Then /^I should be able to enter new password and confirmation password$/ do
  fill_in "cao_password", with: "password"
  fill_in "cao_password_confirmation", with: "password"
end

When /^I click on Change my password$/ do
  click_button "Change my password"
end

Then /^I should be able to see Your password was changed successfully. You are now signed in$/ do
  page.should have_content('Your password was changed successfully. You are now signed in.')
end