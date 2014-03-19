Given /^I select moxy application$/ do
  select "DrFirst - Moxy", from: 'provider_registered_app_id'
end

When /^I select a csv file of valid moxy providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'moxy', 'valid_moxy_providers.csv') # id
end