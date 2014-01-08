When /^I select a csv file with single provider passing WsBatchIdp$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_fields.csv')
end

When /^I select a csv file with single provider failing WsBatchIdp$/ do
	attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_fields.csv')
end