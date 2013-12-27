And /^I should be able to see onestop-router acknowledgement or error messages$/ do
  page.all(:css, "#table1 tbody tr").each do |td|
    # td.text =~ /Connection Error/
    td.has_text?("Connection Error")
  end
end