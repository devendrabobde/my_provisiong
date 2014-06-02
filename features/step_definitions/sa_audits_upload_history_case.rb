And (/^I should be successfully logged out of the application$/) do
  sleep 5
  visit current_path
  if ENV['HEADLESS']
    binding.pry
    # page.execute_script("$('.dropdown-menu').show();")
    # click_link("Logout")
    # # click_link('Logout', href: "/caos/sign_out")
    # page.should have_selector(".sign_in_box")
    # page.driver.submit :delete, "/caos/sign_out", {}
    # http_delete "/caos/sign_out"
    rack_test_session_wrapper = Capybara.current_session.driver
    rack_test_session_wrapper.process :delete, '/caos/sign_out'
  else
    page.execute_script("$('.dropdown-menu').show();")
    click_on('Logout')
    page.should have_selector(".sign_in_box")
  end  
end

Given(/^I click on the organization of COA$/) do
  @current_cao.update_attributes(fk_organization_id: @organization.id)
  @current_cao.audit_trails.first.update_attribute(:fk_organization_id, @organization.id)
  visit application_admin_providers_path
  page.find('table#cao_table tbody tr', text: @organization.name).click_link(@organization.name)
end

Then(/^I should be able to see a list of all csv files uploaded by provider$/) do
	select "EPCS-IDP", from: 'application_registered_app_id'
  sleep 4
  page.all(:css, "#table1 tbody tr").size.should > 0
end

When(/^I click on any csv file from the list$/) do
  page.find("#table1 td:last-child").find(:xpath, '../td/a').click
end

Then(/^I should be able to see the provider details$/) do
  page.should have_content("Total NPI Processed")
  page.should have_selector("table#table2")
  page.all(:css, "#table2 tbody tr").size.should > 0
end

And(/^I should be able to download any previously updated csv file with its providers$/) do
  page.should have_link("Download")
end