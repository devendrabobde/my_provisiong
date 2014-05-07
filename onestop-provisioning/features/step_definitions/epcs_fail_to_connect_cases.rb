And /^I should be able to see (.+?) acknowledgement or error messages$/ do |app_name|
	if app_name == "onestop-router"
		page.all(:css, "#table1 tbody tr").each do |td|
    		td.text.should =~ /Connection Error/
  		end
	else
		page.all(:css, "#table1 tbody tr").each do |td|
	    	td.text.should have_content("Connection refused")
	  	end
	end
end