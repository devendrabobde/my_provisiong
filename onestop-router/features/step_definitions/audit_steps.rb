Then /^the last ([A-Za-z]+) should have been( last)? modified by the (.+)$/ do |audited_class, last_user, user_type|
  user = case user_type
         when /admin user "([^"]+)"/ then
           AdminUser.find_by_email($1)
         when /Ois "([^"]+)"/ then
           Ois.find_by_ois_name $1
         when /client "([^"]+)"/ then
           OisClient.find_by_client_name $1
         else
           raise "#{user_type} not recognized"
         end

  modified_item = audited_class.constantize.last
  audits        = modified_item.audits
  last_audit    = if last_user
                    audits.last
                  else
                    audits.first
                  end

  last_audit.user.should == user
end
