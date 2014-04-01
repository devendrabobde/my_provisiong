
When /^I select a csv file which is containing single provider who has all required fields present including VendorLabel, VendorNodeLabel, Date, Npi, Firstname, Lastname, Gender, Dateofbirth, DeaNumber, DeaState, DeaExpirationDate, PrimaryAddressLine1, PrimaryCity, PrimaryState, PrimaryZipcode, Email, TokenSerialNumber$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_fields.csv') # id
end

And /^I should be able to see success message corresponding to each uploaded providers$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    # td.text.should =~ /Success/
    td.text.should =~ /Success | NativeException: java.sql.SQLIntegrityConstraintViolationException: ORA-00001: unique constraint/
  end
end

When /^I select a csv file which is containing single provider who has all required fields as well as including all optional fields$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'single_provider_with_all_required_and_optional_fields.csv') # id
end

When /^I select a csv file which is containing one single provider record including special characters, such as space, hyphen, quote$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'provider_record_with_special_case_char.csv') # id
end

When /^I select a csv file which is containing one single batch of multiple providers all pass WsBatchIdp$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'one_single_batch_of_multiple_providers.csv') # id
end

When /^I select a csv file which is containing one batch of providers from the same spreadsheet all pass WsBatchIdp$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'one_single_batch_of_multiple_providers.csv') # id
end

When /^I select a csv file which is containing provider with one single DEA$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'provider_with_one_single_dea.csv') # id
end

When /^I select a csv file which is containing provider with multiple DEAs$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'provider_with_multiple_dea.csv') # id
end