Given(/^I select an organization to see the COAs$/) do
	org_cao = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
  	first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
  	password: "password", password_confirmation: "password")
  	role_cao = Role.create(name: "COA")
  	org_cao.update_attributes(fk_role_id: role_cao.id, fk_organization_id: @organization.id)
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
	fill_in "cao_user_id", with: @n_user_id
	fill_in "cao_first_name", with: @n_fname
	fill_in "cao_last_name", with: @n_lname
	fill_in "cao_username", with: @n_username
	fill_in "cao_email", with: @n_email
	fill_in "cao_password", with: "password"
	select "Doctor", from: 'cao_fk_profile_id'
	select "COA", from: "cao_fk_role_id"
	click_button("Create")
end

Then(/^I should see the created CAO saved in provisioning db with username and password$/) do
	page.should have_content("COA was created successfully.")
	page.should have_content("COA Details")
	page.should have_content(@n_user_id)
	page.should have_content(@n_fname)
	page.should have_content(@n_lname)
	page.should have_content(@n_username)
	page.should have_content(@n_email)
	page.should have_content(@organization.name)
end