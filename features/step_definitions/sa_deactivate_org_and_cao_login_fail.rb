And(/^I should be able to deactivate an organization$/) do
  page.find('table#cao_table tbody tr', text: @organization.name).click_link('Deactivate')
  click_button("Deactivate")
  page.find('table#cao_table tbody tr', text: @organization.name).should have_link("Activate")
  page.find('table#cao_table tbody tr', text: @organization.name).should have_content("Inactive")
  page.find('table#cao_table tbody tr', text: @organization.name).should_not have_link("Manage")
end

And (/^I fill in with the username and password$/) do
  fill_in "cao_username", with: @organization.caos.first.username
  fill_in "cao_password", with: "password@123"
end

Then (/^I should see login failed validation message$/) do
  page.should have_content("Your account has been deactivated. Please contact the Administrator.")
end

# And (/^I fill in with the other coa username and password$/) do
#   coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
#     first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
#     password: "password@123", password_confirmation: "password@123")
#   role = Role.create(name: "COA")
#   profile = Profile.create(profile_name: Faker::Name.first_name)
#   coa.update_attributes(fk_role_id: role.id, fk_organization_id: @organization.id, fk_profile_id: profile.id)
#   coa.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: coa.id)
#   @current_cao = coa
#   fill_in "cao_username", with: @current_cao.username
#   fill_in "cao_password", with: "password@123"
# end