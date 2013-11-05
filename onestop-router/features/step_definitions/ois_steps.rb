Given /the "([^"]+)" identity service belongs to the "([^"]+)" organization$/ do |ois_name, org_name|
  ois = Ois.find_by_ois_name(ois_name) or raise "OIS not found with name '#{ois_name}'"
  org = Organization.find_by_organization_name(org_name) or raise "Organization not found with name '#{org_name}'"

  ois.organization = org
  ois.save!
end

Given /^the ois "([^"]+)" is disabled$/ do |ois_name|
  ois = Ois.find_by_ois_name ois_name
  ois.disabled = true
  ois.save!
end

When /^I make an ois save-user request with the following headers:$/ do |table|
  headers = table.rows_hash.collect {|key, value| "#{key}: #{value}"}.join(', ')
  step "I make an API POST request to '/api/v1/ois/save-user' with:", table(%{
        | headers    | #{headers} |
        | npi        | 1234567890 |
        | first_name | Carlos     |
        | last_name  | Casteneda  |
    })
end

Then /^the [oO][iI][sS] should have a user with:$/ do |table|
  @ois.users.where(table.rows_hash.symbolize_keys).should have(1).user
end
