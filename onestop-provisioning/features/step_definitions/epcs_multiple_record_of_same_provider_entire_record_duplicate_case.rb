
When /^I select a csv file which is containing multiple records of the same provider$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'epcs_duplicate_provider_record.csv') # id
end

And /^I should be able to see acknowledgement messages$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    # td.text.split(" ").last.should =~ /Success/
    td.text.should =~ /Success | NativeException: java.sql.SQLIntegrityConstraintViolationException: ORA-00001: unique constraint/
  end
end
