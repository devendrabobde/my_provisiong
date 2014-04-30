Given /^I select rcopia application$/ do
  select "DrFirst - rcopia", from: 'provider_registered_app_id'
end

When /^I select a csv file of valid rcopia providers$/ do
  page.execute_script("$('#upload').show();")
  attach_file 'upload', File.join(Rails.root, 'public', 'rspec_test_files', 'rcopia', 'valid_rcopia_providers.csv') # id
end

When(/^I should be able to verify clean provider data in Provisioning DB for application$/) do
  count = 0
  loop do
    sleep 1
    if !page.find("#table1").has_content?("In Progress..")
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
    break if count > 600
  end
  page.find("#table1 td:last-child").find(:xpath, '..').should have_selector('a')
  page.find("#table1 td:last-child").find(:xpath, '..').should have_selector('a')
  page.find("#table1 td:last-child").find(:xpath, '../td/a').click
  page.all(:css, "#table1 tr").each do |td|
    td.all(:xpath, '//td[1]').should_not == ""
  end
end