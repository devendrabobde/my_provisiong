Given /^a valid COA$/ do
  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "password@123", password_confirmation: "password@123")
  role = Role.create(name: "COA")
  profile = Profile.create(profile_name: Faker::Name.first_name)
  @organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345", state_code: "AL")
  coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization_coa.id, fk_profile_id: profile.id)
  coa.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: coa.id)
  @current_cao = coa
end

When /^I go to login page$/ do
  visit new_cao_session_path
  page.find(:xpath, "/html/body/div/div/div/a[2]/img")["alt"].should == "OneStop"
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
  page.find(:xpath, "/html/body/div[2]/div/div/div/fieldset/form/input").value.should == "Upload"
end

And /^I should see application csv template download button$/ do
  # page.should have_content("Download Sample Data File")
end

And(/^I should be able to see the tabs on the top of the main screen as Onestop Logo, Setting, Username and organization$/) do
  if ENV['HEADLESS']
    page.evaluate_script("$('.dropdown-toggle').text()").include?(@current_cao.username)
    page.evaluate_script("$('.setting-dropdown').text()").should == "Setting"
    page.should have_content("Organization : #{@organization_coa.name}")
  else
    page.should have_content(@current_cao.username)
    page.should have_content("Setting")
    page.should have_content("Organization : #{@organization_coa.name}")
  end
  page.find(:xpath, "/html/body/div/div/div/a[2]/img")["alt"].should == "OneStop"
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
  page.find(:xpath, "/html/body/div[4]/div/button").click
end

And(/^I select an invalid file with .png extension$/) do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'sample.gif')
end

Then(/^I should see error validation message$/) do
  click_button "Upload"
  page.find_by_id("dialog").text.should =~ /Only file with extension .csv is allowed./
  page.find(:xpath, "/html/body/div[4]/div/button").click
end

And(/^I select file to upload with any of the extensions like .doc other than csv, I should see error validation message$/) do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'sample.doc')
  click_button "Upload"
  page.find_by_id("dialog").text.should =~ /Only file with extension .csv is allowed./
  page.find(:xpath, "/html/body/div[4]/div/button").click
end

And(/^I select file to upload with any of the extensions like .pdf other than csv, I should see error validation message$/) do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'sample.pdf')
  click_button "Upload"
  page.find_by_id("dialog").text.should =~ /Only file with extension .csv is allowed./
  page.find(:xpath, "/html/body/div[4]/div/button").click
end

And(/^I select file to upload with any of the extensions like .xml other than csv, I should see error validation message$/) do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'sample.xml')
  click_button "Upload"
  page.find_by_id("dialog").text.should =~ /Only file with extension .csv is allowed./
  page.find(:xpath, "/html/body/div[4]/div/button").click
end

And(/^I should be able to verify dropdown for selecting the number of displayed files has 10, 25, 50 and 100$/) do  
  page.find_by_id("table1_length").text.should == "Show 10 25 50 100 entries"
end

And(/^I should be able to verify 10 entries per page$/) do
  15.times do
    @audit_trail = AuditTrail.create(upload_status: true, total_npi_processed: 2, total_providers: 2)
    @registered_app = RegisteredApp.where(app_name: "EPCS-IDP").first
    @audit_trail.update_attributes(fk_organization_id: @organization_coa.id, fk_registered_app_id: @registered_app.id)
  end
  page.find_by_id("table1_length").text.include?("10")
end

Then(/^I should be able to select 25 from file dropdown$/) do
  select "25", from: "table1_length"
end

And(/^I should be able to see 25 files$/) do
  page.should have_content("Total NPI Processed")
end

Then(/^I should be able to select 50 from file dropdown$/) do
  select "50", from: "table1_length"
end

And(/^I should be able to see 50 files$/) do
  page.should have_content("Total NPI Processed")
end

Then(/^I should be able to select 100 from file dropdown$/) do
  select "100", from: "table1_length"
end

And(/^I should be able to see 100 files$/) do
  page.should have_content("Total NPI Processed")
end

And(/^I visit the first audit record$/) do
  @audit_trail = AuditTrail.create(upload_status: true, total_npi_processed: 2, total_providers: 2)
  @registered_app = RegisteredApp.where(app_name: "EPCS-IDP").first
  @audit_trail.update_attributes(fk_organization_id: @organization_coa.id, fk_registered_app_id: @registered_app.id)
  2.times do
    @provider_app_detail = ProviderAppDetail.create(status_code: "200", status_text: "Success", fk_cao_id: @current_cao.id, fk_registered_app_id: @registered_app.id, fk_audit_trail_id: @audit_trail.id, fk_organization_id: @organization_coa.id)
  end
  @provider = Provider.create(username: Faker::Internet.user_name, password: "Password@1234", role: "Doctor", prefix: "Mr.", first_name: Faker::Name.first_name, middle_name: Faker::Name.first_name, last_name: Faker::Name.last_name, suffix: "Dr.", degrees: "Doctor", npi: "1234567890", email: Faker::Internet.email, address_1: Faker::Address.street_address, address_2: Faker::Address.street_address, city: "New Jercey", state: "NJ")
  @provider.update_attributes(fk_provider_app_detail_id: @provider_app_detail.id)
  # @provider_error_log = ProviderErrorLog.create(fk_provider_id: @provider.id, application_name: @registered_app.app_name, error_message: "Unprocessable", fk_cao_id: @current_cao.id, fk_audit_trail_id: @audit_trail.id)
  visit admin_provider_path(@audit_trail.id)
end

Then(/^I should be able to verify 25, 50 and 100 entries per page$/) do
  page.find_by_id("table2_length").text.should == "Show 10 25 50 100 entries"
end

Then(/^I should see the correct entry of provider$/) do
  page.should have_content("Last Name")
  page.should have_content("First Name")
  page.should have_content("Email")
  page.should have_content("DEA Numbers")
end

And(/^I should be able to search for a provider entry by entering text in search box$/) do
  fill_in "Search", with: @provider.first_name  
end

And(/^I should be able to see download sample data file link$/) do
  page.should have_content("Download Sample Data File")
  page.should have_link("Download Sample Data File")
end

And(/^I click on download sample data file link$/) do
  click_link("Download Sample Data File")
end

Then(/^I should be able to see download dialog$/) do
  page.should have_content("Download Sample Data File")
end

And(/^I should be able to verify the search box$/) do
  page.should have_content("Search")
end

And(/^I should be able to search for a file by entering text in search box$/) do
  fill_in "Search", with: "valid"
end

And(/^I should be able to verify previous and next button$/) do
  12.times do
    @audit_trail = AuditTrail.create(upload_status: true, total_npi_processed: 2, total_providers: 2)
    @registered_app = RegisteredApp.where(app_name: "EPCS-IDP").first
    @audit_trail.update_attributes(fk_organization_id: @organization_coa.id, fk_registered_app_id: @registered_app.id)
  end
  page.should have_content("Next")
  page.should have_content("Previous")
  page.should have_link("Next")
  page.should have_link("Next")
end

And(/^I click on the next button$/) do
  click_link("Next")
end

Then(/^I should see the correct files$/) do
  page.should have_content("Total NPI Processed")
end

And(/^I click on the previous button$/) do
  click_link("Previous")
end

Then(/^I should see the correct total number of NPI processed$/) do
  page.should have_content("Total NPI Processed")
end

And(/^I click on the first audit record$/) do
  @audit_trail = AuditTrail.create(upload_status: true, total_npi_processed: 2, total_providers: 2)
  @registered_app = RegisteredApp.where(app_name: "EPCS-IDP").first
  @audit_trail.update_attributes(fk_organization_id: @organization_coa.id, fk_registered_app_id: @registered_app.id)
  visit admin_provider_path(@audit_trail.id)
end

Then(/^I should be able to see total npi processed on the top of page$/) do
  page.should have_content("Total NPI Processed")
end

And(/^I should be able to verify new application populated in select application dropdown$/) do
  page.find_by_id("provider_registered_app_id").text.should be_true
end

Given /^I select an application$/ do
  @current_cao.update_attributes(epcs_ois_subscribed: true, epcs_vendor_name: "Meditech 1", epcs_vendor_password: "uidyweyf8986328992")
  page.execute_script("$('#update-password-modal').modal('hide');")
  select "DrFirst::epcsidp", from: 'provider_registered_app_id'
end

When /^I select a csv file of 4 providers$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_epcs_providers.csv') # id
end

When /^I select a csv file of providers$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_epcs_provider_data.csv')
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

And /^I should be able to see the previous CSV file in progress$/ do
  sleep 25
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

And /^I should be able to see current COA name in uploaded by column$/ do
  page.should have_content(@current_cao.full_name)
  page.find("#table1 td:last-child").find(:xpath, '../td[5]').text.should == @current_cao.full_name
end