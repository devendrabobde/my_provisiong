And /^I should be able to see error messages and Pending status from destination OIS$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should_not =~ /Success/
  end
end