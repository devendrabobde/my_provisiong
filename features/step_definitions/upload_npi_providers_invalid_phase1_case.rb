When /^I select CSV File of Invalid providers$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'epcs_invalid.csv') # id
end

And /^I should be able to see invalid file upload message$/ do
  page.should have_content("Providers required fields can't be blank, please correct")
end

And /^No data should be uploaded in the provisioning db$/ do
  page.should have_content("No data available in table")
  # sleep 60
end

When(/^No Audit data should be added in the Provisioning db$/) do
  page.find("#table1 td:last-child").find(:xpath, '..').should_not have_selector('a')
  # sleep 60
end
