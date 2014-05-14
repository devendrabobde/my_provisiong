And /^SuperNpi should have expected result$/ do
  page.should have_content("In Progress..")
end

And /^EPCS should have the expected result$/ do
  page.should have_content("In Progress..")
end

And /^Router should have the expected result$/ do
  page.should have_content("In Progress..")
end

And /^I should be able to see expected result on UI$/ do
  page.all(:css, "#table2 tbody tr").each do |td|
    td.text.should =~ /Success/
  end
end