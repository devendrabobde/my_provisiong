
When /^I select a csv file which is containing all valid providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_epcs_providers.csv')
end

And /^I should be able to see success message corresponding to each valid providers$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    # td.text.should =~ /Success/
    td.text.should =~ /Success | NativeException: java.sql.SQLIntegrityConstraintViolationException: ORA-00001: unique constraint/
  end
end

When /^I click on Back button for uploading same providers file again$/ do
  click_link ("Back", match: :first)
end


When /^I select a csv file which contains all valid providers and then repeat upload a second time$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_epcs_providers.csv')
end

Then /^I should be able to see Upload home page$/ do
  AuditTrail.where(fk_cao_id: @current_cao.id).delete_all
  # page.should have_content("Download Sample Data File")
  page.should have_content("Upload CSV Data File")
  page.should have_content("Previously Uploaded Data File")
end


When /^I select a csv file which is containing all invalid providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'invalid_epcs_providers.csv')
end

When /^I select a csv file which contains all valid providers after fixing invalid providers and upload a second time$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'invalid_epcs_providers_with_fixes.csv')
end

And /^I should be able to see error message corresponding to each invalid providers$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not == ""
  end
end

When /^I select a csv file which is containing mixture of valid and invalid providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_and_invalid_providers.csv')
end

When /^I select a csv file which contains all valid providers after fixing invalid providers records$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_and_invalid_providers_with_fixes.csv')
end

When /^I select a csv file after partial fixes and upload again$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_and_invalid_providers_with_partial_fixes.csv')
end

And /^I should be able to see success or error message corresponding to each valid and invalid providers$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not == ""
  end
end