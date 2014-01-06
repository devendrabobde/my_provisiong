
When /^I select a csv file which is containing one single batch of multiple providers, some pass WsBatchIdp, while the others fail WsBatchIdp$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'batch_of_multiple_providers_some_pass_wsbatchidp_some_are_fail.csv')
end

And /^I should be able to see success or failure message corresponding to each uploaded providers$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not == ""
  end
end

When /^I select a csv file which is containing more than one batch of providers from the same spreadsheet, some pass WsBatchIdp, while the others fail WsBatchIdp$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'more_than_one_batch_of_multiple_providers_some_pass_wsbatchidp_some_are_fail.csv')
end