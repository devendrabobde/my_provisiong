And /^I should be able to see job in history, error messages and Pending status$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should =~ /Success/
  end
end