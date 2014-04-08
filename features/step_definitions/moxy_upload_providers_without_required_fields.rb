When /^I select a csv file of providers with missing required field for (.+?)$/ do |app_name|
    page.execute_script("$('#upload').show();")
    attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', app_name, "#{app_name}_providers_missing_required_field.csv")
end

When /^I select a csv file of providers with missing multiple required fields for (.+?)$/ do |app_name|
    page.execute_script("$('#upload').show();")
    attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', app_name, "#{app_name}_providers_missing_multiple_required_fields.csv")
end
