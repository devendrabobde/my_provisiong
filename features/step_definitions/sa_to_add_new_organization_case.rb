Given(/^a valid SA$/) do
admin = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
password: "password", password_confirmation: "password")
role = Role.create(name: "Admin")
# organization = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address, 
# address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name, 
# contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email)
coa.update_attributes(fk_role_id: role.id)
@current_cao = admin
end