Given /^a valid COA$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name, 
    password: "password", password_confirmation: "password")
  role = Role.create(name: "COA")
  organization = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address, 
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name, 
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email)
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: organization.id)
  @current_cao = coa
end

When /^I go to login page$/ do
  visit new_cao_session_path
end

And /^I fill in the username and password$/ do
  fill_in "cao_username", with: @current_cao.username
  fill_in "cao_password", with: "password"
end

And /^I press "Sign in"$/ do
  click_button "Sign in"
end

Then /^I should see success message$/ do
  page.should have_content("Signed in successfully")
end

And /^I should see correct screen title$/ do
  page.should have_content("OneStop")
end

And /^I should see application selection list$/ do

  page.find_by_id("provider_registered_app_id").text.should =~ /Select Application/
end

And /^I should see file selection button$/ do
  page.should have_selector("input[type=file][name='upload']")
end

And /^I should see application csv template download button$/ do
  page.should have_content("Download Sample Data File")
end

And /^I should see correct section names$/ do
  page.should have_content("Upload CSV Data File")
  page.should have_content("Previously Uploaded Date File")
end
Given /^I go to application page$/ do
  visit application_admin_providers_path
end
And /^I click on file upload button$/ do
  click_button "Upload"
end
Then /^I should see message Please select application and a CSV file to initiate the provisioning process$/ do
  page.find_by_id("dialog").text.should =~ /Please select application and a CSV file to initiate the provisioning process./
end

Given /^I select an application$/ do
  select "EPCS-IDP", from: 'provider_registered_app_id'
end

When /^I selects a csv file of 4 providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'epcs_valid.csv') # id
end

And /^I clicks upload button$/ do
  click_button "Upload"
end

And /^I should be able to see correct file upload message$/ do
  page.should have_content("Thanks for uploading providers, we are processing uploaded file.")
end

And /^I should be able to see progress bar$/ do
  page.should have_content("In Progress ..")
end

And /^I should be able to see application info, upload time, file name, download button$/ do
  page.should have_content("epcs_valid.csv")
  page.should have_content("EPCS-IDP")
  page.should have_content(Time.now.strftime("%m/%d/%Y"))
  page.should have_content("Download Sample Data File")
end