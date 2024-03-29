Given /^I go to application home page$/ do
  visit new_cao_session_path
end

Then /^I should be able to see forgot password link$/ do
  page.should have_content("Forgot username or password?")
end

And /^I should be able to click on forgot password link$/ do
  click_link "Forgot username or password?"
end

Then /^I should see the validation error message as This field is required$/ do
  page.should have_content("This field is required.")
end

When /^I enter invalid email in email field on form$/ do
  fill_in "cao_email", with: "andrew"
end

Then /^I should see the validation error message as Please enter a valid email address$/ do
  page.should have_content("Please enter a valid email address.")
end

When /^I enter email on the reset password form$/ do
  @coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "Password@123", password_confirmation: "Password@123", security_question: "What was your childhood nickname?", security_answer: "scott")
  role = Role.create(name: "COA")
  profile = Profile.create(profile_name: Faker::Name.first_name)
  organization = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
  @coa.update_attributes(fk_role_id: role.id, fk_organization_id: organization.id, fk_profile_id: profile.id)
  fill_in "cao_email", with: @coa.email
end

And /^I select username option$/ do
  choose("forgot_field_1")
end

And /^I press Send me reset password instructions button$/ do
  click_button "Send Me Username/Password Revival Instructions"
end

Then /^I sould be able to see You will receive an email with requested instructions in a few minutes$/ do
  page.should have_content("You will receive an email with requested instructions in a few minutes.")
end

And /^I should receive email with forget password instructions$/ do
  unread_emails_for(@coa.email).size.should >= parse_email_count(1)
end

When /^I open email then I should be able to see username in email$/ do
  email = open_email(@coa.email, with_subject: "Requested Username From Onestop")
  email.should have_body_text(/You have requested the username for Onestop Login./)
  email.should have_body_text(/#{@coa.username}/)
end

When /^I open email then I should be able to see Change my password link$/ do
  email = open_email(@coa.email, with_subject: "Reset password instructions")
  email.should have_body_text(/Change my password/)
end

And /^I follow Change my password link in the email$/ do
  click_first_link_in_email
end

Then /^I should be able to enter new password and confirmation password$/ do
  fill_in("cao_password", with: "Password@12345")
  fill_in("cao_password_confirmation", with: "Password@12345")
  fill_in("cao_security_answer", with: "scott")
end

When /^I click on Change my password$/ do
  click_button "Change my password"
end

Then /^I should be able to see Your password was changed successfully. You are now signed in$/ do
  page.should have_content('Your password was changed successfully. You are now signed in.')
end

When /^I open an email then I should be able to see Change my password link$/ do
  Cao.where(email: @coa.email).first.update_attributes(reset_password_token: nil, reset_password_sent_at: nil)
  email = open_email(@coa.email, with_subject: "Reset password instructions")
  email.should have_body_text(/Change my password/)
end

When /^I open my email then I should be able to see Change my password link$/ do
  Cao.where(email: @coa.email).first.update_attributes(reset_password_sent_at: (Time.now-1.day))
  email = open_email(@coa.email, with_subject: "Reset password instructions")
  email.should have_body_text(/Change my password/)
end

Then /^I should be able to see message as Reset password token has expired. please request a new one$/ do
  page.should have_content("Reset password token has expired. please request a new one")  
end
