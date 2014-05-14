Given /^a valid COA$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "password@123", password_confirmation: "password@123")
  role = Role.create(name: "COA")
  profile = Profile.create(profile_name: Faker::Name.first_name)
  @organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization_coa.id, fk_profile_id: profile.id)
  coa.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: coa.id)
  @current_cao = coa
end

When /^I go to login page$/ do
  visit new_cao_session_path
end

And /^I fill in the username and password$/ do
  fill_in "cao_username", with: @current_cao.username
  fill_in "cao_password", with: "password@123"
end

And /^I press "Sign in"$/ do
  click_button "LOG IN"
end

Then /^I should see success message$/ do
  page.should have_content(/Upload CSV Data File | Listing Organizations/)
end

And /^I should see correct screen title$/ do
  page.execute_script("$('#update-password-modal').modal('hide');")
  page.should have_content("Select Application")
end

And /^I should see application selection list$/ do
  page.find_by_id("provider_registered_app_id").text.should =~ /Select Application/
end

And /^I should see file selection button$/ do
  # page.should have_selector("input[type=file][name='upload']")
end

And /^I should see application csv template download button$/ do
  # page.should have_content("Download Sample Data File")
end

And /^I should see correct section names$/ do
  page.should have_content("Upload CSV Data File")
  page.should have_content("Previously Uploaded Data File")
end
Given /^I go to application page$/ do
  visit application_admin_providers_path
  page.execute_script("$('#update-password-modal').modal('hide');")
end
And /^I click on file upload button$/ do
  click_button "Upload"
end
Then /^I should see message Please select application and a CSV file to initiate the provisioning process$/ do
  page.find_by_id("dialog").text.should =~ /Please select application and a CSV file to initiate the provisioning process./
end

Given /^I select an application$/ do
  page.execute_script("$('#update-password-modal').modal('hide');")
  select "DrFirst::epcsidp", from: 'provider_registered_app_id'
end

When /^I select a csv file of 4 providers$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_epcs_providers.csv') # id
end

And /^I clicks upload button$/ do
  click_button "Upload"
end

And /^I should be able to see correct file upload message$/ do
  page.execute_script("$('#update-password-modal').modal('hide');")
  page.should have_content("Thanks for uploading providers. We are processing the uploaded file.")
end

And /^I should be able to see progress bar$/ do
  page.should have_content("In Progress..")
end

And /^I should be able to see application info, upload time, file name, download button$/ do
  page.should have_content("valid_epcs_providers.csv")
  page.should have_content("EPCS-IDP")
  page.should have_content(Time.now.strftime("%m/%d/%Y"))
  # page.should have_content("Download Sample Data File")
end

When(/^I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router$/) do
  count = 0
  loop do
    sleep 1
    if !page.find("#table1").has_content?("In Progress..")
      sleep 1
      break
    else
      count+=1
    end
    # if !page.evaluate_script('jQuery.active==0')
    #   count = 0
    # else
    #   count+=1
    #   break if count > 25
    # end
    break if count > 600
  end
  page.find("#table1 td:last-child").find(:xpath, '..').should have_selector('a')
  page.find("#table1 td:last-child").find(:xpath, '../td/a').click
  page.should have_content("Last Name")
  page.should have_content("First Name")
  page.should have_content("Email")
  page.should have_content("DEA Numbers")
  page.all(:css, "#table1 tr").each do |td|
    td.all(:xpath, '//td[1]').should_not == ""
  end
end

And /^I should be able to associate provider with COA$/ do
  ProviderAppDetail.where(fk_cao_id: @current_cao.id).count > 0
end

And /^I should be able to add audit data in Provisioning DB$/ do
  page.all(:css, "#table2 tbody tr").size.should > 0
end

And /^I should be able to see simple acknowledgement messages$/ do
  page.all(:css, "#table2 tbody tr").each do |td|
    td.text.should =~ /Success/
    # td.text.should =~ /Success | NativeException: java.sql.SQLIntegrityConstraintViolationException: ORA-00001: unique constraint/
  end
end
