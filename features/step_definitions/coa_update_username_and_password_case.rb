Given(/^I click on edit account link in setting section$/) do
  click_on('Setting')
  click_on('Edit Account')
end

Then(/^I should be able to see edit account form$/) do
  page.should have_button('Update')
end

And(/^I click on update with the information that needs to be changed including correct old password$/) do
  fill_in('cao_password', :with => 'password')
  fill_in('cao_password_confirmation', :with => 'password')
  fill_in('cao_current_password', :with => 'password')
  click_on('Update')
end

Then(/^I should see success message You updated your account successfully$/) do
  page.should have_content("You updated your account successfully")
end