Given(/^I select an organization to see the COAs$/) do
	role_cao1 = Role.create(name: "COA")
	@org_cao = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
  	first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
  	password: "password@123", password_confirmation: "password@123")
  	@profile = Profile.create(profile_name: "Test")
  	@org_cao.update_attributes(fk_role_id: role_cao1.id, fk_organization_id: @organization.id, fk_profile_id: @profile.id)
	page.find('table#cao_table tbody tr', text: @organization.name).click_link('Manage')
end

Then(/^I should see the list of all COAs of that organization$/) do
	page.should have_content("Listing COAs for #{@organization.name}")
	@organization.caos.each do |org_cao|
		page.should have_content(org_cao.first_name)
		page.should have_content(org_cao.last_name)
		page.should have_content(org_cao.username)
		page.should have_content(org_cao.email)
	end
end

When(/^I proceed for creating the COA$/) do
 	click_link("Create COA")
end

Then(/^I should see the form for creating the coa$/) do
	page.should have_content("Create COA")
	page.should have_selector("form#new_cao")
	page.should have_button("Create")
end

When(/^I submit the form with proper values$/) do
	@n_user_id = Faker::Internet.user_name
	@n_fname = Faker::Name.first_name
	@n_lname = Faker::Name.last_name
	@n_username = Faker::Internet.user_name
	@n_email = Faker::Internet.email
	fill_in "cao_first_name", with: @n_fname
	fill_in "cao_last_name", with: @n_lname
	fill_in "cao_username", with: @n_username
	fill_in "cao_email", with: @n_email
	# select "Doctor", from: "cao_fk_profile_id"
	find('#cao_fk_profile_id').find(:xpath, 'option[2]').select_option
	click_button("Create")
end

Then(/^I should see the created CAO saved in provisioning db with username and password$/) do
	page.should have_content("COA was created successfully.")
	page.should have_content("COA Details")
	page.should have_content(@n_fname)
	page.should have_content(@n_lname)
	page.should have_content(@n_username)
	page.should have_content(@n_email)
	page.should have_content(@organization.name)
end


Then(/^I should be able to delete any COA from that list$/) do
	page.find('table#cao_table tbody tr', text: @org_cao.username).click_link('Deactivate')
	click_button("Deactivate")
end

Then(/^the COA should be deactivated$/) do
	page.find('table#cao_table tbody tr', text: @org_cao.username).should have_content("Inactive")
	page.find('table#cao_table tbody tr', text: @org_cao.username).should have_link("Activate")
end

When(/^I click on edit for any COA$/) do
	page.find('table#cao_table tbody tr', text: @org_cao.username).click_link('Edit')
end

Then(/^I should see edit coa form for SA$/) do
	page.should have_content("Edit COA")
	page.should have_button("Update")
end

When(/^I update the edit COA form with proper fields$/) do
	@e_user_id = Faker::Internet.user_name
	@e_fname = Faker::Name.first_name
	@e_lname = Faker::Name.last_name
	@e_username = Faker::Internet.user_name
	@e_email = Faker::Internet.email
	fill_in "cao_first_name", with: @e_fname
	fill_in "cao_last_name", with: @e_lname
	fill_in "cao_username", with: @e_username
	fill_in "cao_email", with: @e_email
	click_button("Update")
end

Then(/^the COA should be updated with username and password$/) do
 	page.should have_content("COA was updated successfully.")
	page.should have_content("COA Details")
	page.should have_content(@e_fname)
	page.should have_content(@e_lname)
	page.should have_content(@e_username)
	page.should have_content(@e_email)
	page.should have_content(@organization.name)
end

When(/^I click on show for any COA$/) do
  page.find('table#cao_table tbody tr', text: @org_cao.username).click_link('Show')
end

Then(/^I should be able to view that COAs details$/) do
	page.should have_content("COA Details")
	page.should have_content(@org_cao.username)
	page.should have_content(@org_cao.first_name)
	page.should have_content(@org_cao.last_name)
	page.should have_content(@org_cao.email)
	page.should have_content(@organization.name)
end

Then(/^I should be able to activate an inactive COA$/) do
	@org_cao.update_attribute(:deleted_at, Time.now)
	visit page.driver.browser.current_url
	page.find('table#cao_table tbody tr', text: @org_cao.username).should have_link('Activate')
	page.find('table#cao_table tbody tr', text: @org_cao.username).should have_content("Inactive")
	page.find('table#cao_table tbody tr', text: @org_cao.username).click_link('Activate')
	click_button("Activate")
	page.find('table#cao_table tbody tr', text: @org_cao.username).should have_link('Deactivate')
	page.find('table#cao_table tbody tr', text: @org_cao.username).should have_content("Active")
end
