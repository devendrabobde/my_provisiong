Given /^I select rcopia application$/ do
  select "Rcopia", from: 'provider_registered_app_id'
end

When /^I select a csv file of valid rcopia providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'rcopia', 'valid_rcopia_providers.csv') # id
end