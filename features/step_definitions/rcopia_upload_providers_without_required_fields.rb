When /^I select a csv file of providers without required fields for rcopia$/ do
    attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'rcopia', 'rcopia_providers_without_required_fields.csv') # id
end


And /^I should be able to see error message for Rcopia required fields$/ do
  page.should have_content("Providers required fields can't be blank, please correct")
end

And /^the file should not be uploaded$/ do
  page.all(:css, "#table1 tbody").should_not have_content("rcopia_providers_without_required_fields")
end