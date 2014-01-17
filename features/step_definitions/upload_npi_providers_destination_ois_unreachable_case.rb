And /^I should be able to see error messages and status for the OIS being unreachable$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.split(" ").last.should =~ /EPCS-IDP OIS: EPCS-IDP Connection refused/
  end
end