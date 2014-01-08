When /^I select a csv file with single provider passing WsBatchIdp$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_fields.csv')
end

When /^I select a csv file with single provider failing WsBatchIdp$/ do
	@app_validation = RegisteredApp.where(app_name: "EPCS-IDP").first.app_upload_fields.where(name: 'state').first
	@app_validation.update_attribute(:required, false)
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_fields.csv')
end

When /^I select a csv file with single provider passing WsBatchIdp and with already registered Organization$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_passing_batchidp.csv')
end

And /^I should be able to see the error message from WsBatchIdp$/ do
	@app_validation.update_attribute(:required, true)
	page.all(:css, "#table1 tbody tr").each do |td|
    	td.text.split(" ").last.should_not =~ /Success/
  	end
end


When /^When I select csv file having single provider failing WsBatchIdp and with registered Organization$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_failing_batchidp.csv')
end