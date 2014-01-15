And /^I should be able to see EPCS acknowledgement or error messages$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.should =~ /EPCS-IDP OIS: EPCS-IDP Connection refused/
  end
end