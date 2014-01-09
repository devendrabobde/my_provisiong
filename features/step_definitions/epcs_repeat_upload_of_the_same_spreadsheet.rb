
When /^I select a csv file which is containing all valid providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_epcs_providers.csv')
end

And /^I should be able to see success message corresponding to each valid providers$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should =~ /Success/
  end
end

When /^I click on Back button for uploading same providers file again$/ do
  click_link "Back"
end


When /^I select a csv file which is containing all valid providers and then repeat upload a second time$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'valid_epcs_providers.csv')
end

Then /^I should be able to see Upload home page$/ do
  AuditTrail.where(fk_cao_id: @current_cao.id).delete_all
  page.should have_content("Download Sample Data File")
  page.should have_content("Upload CSV Data File")
  page.should have_content("Previously Uploaded Data File")
end


When /^I select a csv file which is containing all invalid providers$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'invalid_epcs_providers.csv')
end

When /^I select a csv file which is containing all valid providers after fixing csv file$/ do
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'invalid_epcs_providers_with_fixes.csv')
end

And /^I should be able to see error message corresponding to each invalid providers$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not == ""
  end
end