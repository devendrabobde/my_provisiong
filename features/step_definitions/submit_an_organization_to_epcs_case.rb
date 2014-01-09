When /^I select a csv file with single provider passing WsBatchIdp$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_fields.csv')
end

When /^I select a csv file with single provider failing WsBatchIdp$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_failing_batchidp.csv')
end

When /^I select a csv file with single provider passing WsBatchIdp and with already registered Organization$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_passing_batchidp.csv')
end

And /^I should be able to see the error message from WsBatchIdp$/ do
	@app_validation = RegisteredApp.where(app_name: "EPCS-IDP").first.app_upload_fields.where(name: 'state').first
  @app_validation.update_attribute(:required, true)
	page.all(:css, "#table1 tbody tr").each do |td|
    	td.text.split(" ").last.should_not =~ /Success/
  	end
end


When /^When I select csv file having single provider failing WsBatchIdp and with registered Organization$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_failing_batchidp.csv')
end

When(/^I redirect back to home page$/) do
	click_link "Back"
end

When(/^I select csv file having single provider failing WsBatchIdp and with already registered Organization$/) do
	@app_validation = RegisteredApp.where(app_name: "EPCS-IDP").first.app_upload_fields.where(name: 'state').first
	@app_validation.update_attribute(:required, false)
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_fields.csv')
end

And(/^I should be able to verify clean provider data in Provisioning DB, and click on the second csv file$/) do
	count = 0
  loop do
    sleep 1
    if !page.find("#table1").has_content?("In Progress ..")
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
  #page.find("#table1 td:last-child").find(:xpath, '..').should have_selector('a')
  page.should have_link("2")
  # page.find("#table1 td:last-child").find(:xpath, '../td/a').click
  click_link("2")
  page.should have_content("Last Name")
  page.should have_content("First Name")
  page.should have_content("Email")
  page.should have_content("DEA Numbers")
  page.all(:css, "#table1 tr").each do |td|
    td.all(:xpath, '//td[1]').should_not == ""
  end
end