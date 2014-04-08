When /^I select a csv file which contains single batch of multiple providers for failing wsbatchldp$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'one_single_batch_of_multiple_provides_wsbatchIdp_fails.csv') # id
end


And /^I should be able to see failure message for failed WsBatchIdp$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not =~ /Success/
  end
end