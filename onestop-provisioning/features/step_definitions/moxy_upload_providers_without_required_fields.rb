When /^I select a csv file of providers without required fields for (.+?)$/ do |app_name|
    attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', app_name, "moxy_providers_missing_required_field.csv.csv")
end


And /^I should be able to see error message for required fields$/ do
  page.should have_content("Providers required fields can't be blank, please correct")
end

And /^the file should not be uploaded$/ do
  page.all(:css, "#table1 tbody").should_not have_content("rcopia_providers_without_required_fields")
end


When /^I select a csv file of providers with missing multiple required fields for (.+?)$/ do |app_name|
    attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', app_name, "moxy_providers_missing_multiple_required_fields.csv")
end