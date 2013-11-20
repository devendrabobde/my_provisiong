And(/^I should be able to view any previously uploaded csv and its providers$/) do
  page.all(:css, "#table1 tbody tr").size.should > 0
  page.all(:css, "#table1 tbody tr").each do |td|
    td.text.should_not == ""
  end
end



And(/^I should be able to download any previously uploaded csv and its providers$/) do
  click_link "Download Sample Data File"
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
