When /^I select a csv file of invalid providers for rcopia$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'rcopia', 'invalid_rcopia_providers.csv') # id
end

And /^I should be able to see error messages for rcopia invalid file$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not =~ /Success/
  end
end