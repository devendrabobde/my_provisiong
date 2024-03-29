And /^I should be able to see job in history$/ do
  page.all(:css, "#table2 tbody tr").size.should > 0
end

And /^I should be able to see error messages and Pending status$/ do
  page.all(:css, "#table2 tbody tr").each do |td|
    td.text.split(" ").last.should =~ /Success/
    # td.text.should =~ /Success | NativeException: java.sql.SQLIntegrityConstraintViolationException: ORA-00001: unique constraint/
  end
end
