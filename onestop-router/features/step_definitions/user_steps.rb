Given /^I have a user for the "(.*)" identity service with:?$/ do |ois_name, user_table|
  ois = Ois.find_by_ois_name(ois_name)
  user_hash = user_table.rows_hash
  user = User.find_by_npi(user_hash['npi']) || create(:user, user_hash)

  ois.users << user
  ois.save!
end
