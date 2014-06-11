Then(/^I should see "(.*?)"$/) do |content|
  if ENV['HEADLESS']
    # page.find(:xpath, "/html/body/div/div/div/div/ul/li[3]").text.should == content
  else
    page.should have_content(content)
  end
end

And(/^I click on browser back button$/) do
  page.evaluate_script('window.history.back()')
  page.driver.browser.switch_to.alert.accept
end

Then(/^I should be able to see validation error message$/) do
  page.should have_content("You have been logged out. Please sign in to continue using the system.")
end

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
  @sec_ans = "scott"
  select "What was your childhood nickname?", from: "cao_security_question"
  fill_in "cao_security_answer", with: @sec_ans
  click_button("Update")
end

Then(/^I should see success message You updated your account successfully$/) do
  page.should have_content("You updated your account successfully.")
end

And(/^I click on update with the information that needs to be changed including correct personal information$/) do 
  @ufname = 'Sarah'
  @ulname = 'Parkar'
  @uemail = 'sarahparkar@onestop.com'
  fill_in('cao_first_name', with: @ufname)
  fill_in('cao_last_name', with: @ulname)
  fill_in('cao_email', with: @uemail)
  click_button("Update")
end

Then(/^I should see the information being updated$/) do
  page.should have_content(@ufname)
  page.should have_content(@ulname)
  page.should have_content(@uemail)
end

Then(/^I should see an error message indicating password is incorrect$/) do
  page.should have_content("Invalid username or password.")
end

Then(/^I fill in username and updated password$/) do
  fill_in "cao_username", with: @current_cao.username
  fill_in "cao_password", with: "password@12345"
end