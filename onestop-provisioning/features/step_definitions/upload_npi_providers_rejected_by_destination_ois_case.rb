And /^I should be able to see error messages for NPI providers rejected by destination OIS$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not =~ /Success/
  end
end


When /^I select a csv file which has providers that would be rejected by destination OIS$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'epcs_invalid.csv') # id
end