And (/^I should be successfully logged out of the application$/) do
  if ENV['HEADLESS']
    # Capybara.reset_sessions!
    # delete destroy_cao_session_path
    # visit root_path
    visit back_button_destroy_path    
    page.should have_content("You have been logged out. Please sign in to continue using the system.")
  else
    page.execute_script("$('.dropdown-menu').show();")
    click_on('Logout')
  end
  page.should have_selector(".sign_in_box")
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