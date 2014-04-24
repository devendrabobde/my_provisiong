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