Given(/^I click on edit account link in setting section$/) do
  visit edit_cao_registration_path
end

Then(/^I should be able to see edit account form$/) do
  # page.should have_button('Update')
  page.should have_content("Personal Information")
end

And(/^I click on update with the information that needs to be changed including correct old password$/) do
  # fill_in('cao_password', :with => 'password@12345')
  # fill_in('cao_password_confirmation', :with => 'password@12345')
  # fill_in('cao_current_password', :with => 'password@123')
  # click_on('Update')
end

Then(/^I should see success message You updated your account successfully$/) do
  # page.should have_content("You updated your account successfully")
end
