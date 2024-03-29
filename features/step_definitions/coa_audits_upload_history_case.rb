And(/^I should be able to view any previously uploaded csv and its providers$/) do
  page.all(:css, "#table1 tbody tr").size.should > 0
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.should_not == ""
  end
end



And(/^I should be able to download any previously uploaded csv and its providers$/) do
  step "I select an application"
  sleep 2
  page.should have_link("Download Sample Data File")
end

And(/^I should be able to download csv file of the registered application providers$/) do
  count = 0
  loop do
    sleep 1
    if !page.find("#table1").has_content?("In Progress ..")
      sleep 1
      break
    else
      count+=1
    end
    # if !page.evaluate_script('jQuery.active==0')
    #   count = 0
    # else
    #   count+=1
    #   break if count > 25
    # end
    break if count > 200
  end
  page.find("#table1 td:last-child").find(:xpath, '..').should have_selector('a')
  page.find("#table1 td:last-child").find(:xpath, '../td/a').click
  page.should have_link("Download")
end


When(/^I select a csv file of providers which returns different error codes and messages$/) do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'epcs', 'providers_with_diff_errors.csv') # id
end

When(/^I should see uploaded csv file status with different error codes and messages$/) do
  page.find('tr', text: '1194718007').should have_content(/422 | Invalid DEA Number Checksum/)
  page.find('tr', text: '1083607999').should have_content(/422 | NPI Checksum Invalid/)
  page.find('tr', text: '1386637106').should have_content(/422 | ProviderDeaState is not in correct format/)
  page.find('tr', text: '1194718130').should have_content(/422 | Provider Name is not matching with Super NPI record/)
end
