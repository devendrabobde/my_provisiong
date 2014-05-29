And(/^I click on edit account link in setting section$/) do
  @current_cao.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: @current_cao.id)
  if ENV['HEADLESS']
    page.execute_script("$('#update-password-modal').modal('hide');")
    page.execute_script("$('.edit-personal-info-modal').modal('show');")
  else
    page.execute_script("$('#update-password-modal').modal('hide');")
    click_link("Setting")
    click_link("Edit Personal Info")
  end  
  @current_cao.old_passwords.delete_all
end

Then(/^I should be able to see edit account form$/) do
  page.should have_content("Personal Information")
end

When(/^I click on change password link in setting section$/)do
  @current_cao.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: @current_cao.id)
  if ENV['HEADLESS']
    page.execute_script("$('#update-password-modal').modal('hide');")
    page.execute_script("$('.change-cao-password-modal').modal('show');")
  else
    page.execute_script("$('#update-password-modal').modal('hide');")
    click_link("Setting")
    click_link("Change Password")  
  end
  @current_cao.old_passwords.delete_all
end

Then (/^I should be able to see change password form$/) do
  page.should have_content("Change Password")
end

And(/^I click on update with the information that needs to be changed including correct old password$/) do
  fill_in('cao_current_password', with: 'password@123')
  fill_in('cao_password', with: 'password@12345')
  fill_in('cao_password_confirmation', with: 'password@12345')
  click_button("Update")
end

Then(/^I should see success message You updated your account successfully$/) do
  page.should have_content("You updated your account successfully.")
end

And(/^I click on update with the information that needs to be changed including correct personal information$/) do
  fill_in('cao_first_name', with: 'Sarah')
  fill_in('cao_last_name', with: 'Parkar')
  fill_in('cao_email', with: 'sarahparkar@onestop.com')
  click_button("Update")
end