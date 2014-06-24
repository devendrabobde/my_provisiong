# Setup default user roles
role_list = ["Admin","COA"]
role_list.each { |name| Role.where(:name => name).first_or_create }

# Setup Super Admin account
cao = Cao.where(username: "superadmin").first_or_create
cao.email = "superadmin@onestop.com"
cao.password = "password@1234" if cao.new_record?
cao.first_name = "super"
cao.last_name = "admin"
cao.fk_role_id = Role.where(:name => "Admin").first_or_create.id
cao.save!

# Setup default profiles
profile_list = ["Doctor","Nurse"]
profile_list.each {|profile| Profile.where(profile_name: profile).first_or_create! }


RegisteredApp.delete_all


## The display_name column should have the name of Organization and name of OIS from Router concatenated by a '::'
applications = [{ app_name: "EPCS-IDP", display_name: "DrFirst::epcsidp"},
                { app_name: "Rcopia", display_name: "DrFirst::rcopia"},
                { app_name: "Moxy", display_name: "DrFirst::moxy"},
                { app_name: "Backline", display_name: nil }]


applications.each do |app|
  RegisteredApp.where(app_name: app[:app_name], display_name: app[:display_name]).first_or_create!
end