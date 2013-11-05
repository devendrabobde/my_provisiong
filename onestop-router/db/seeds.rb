require 'factory_girl'

unless OisClientPreference.default.present?
  FactoryGirl.create(:default_ois_client_preference)
end


AdminUser.create!(:user_name => 'admin', :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')
