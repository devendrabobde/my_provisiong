Given /^I'm using a client account associated with the client preference named "(.*)"$/ do |client_name|
  @client = create(:ois_client, :ois_client_preference => OisClientPreference.find_by_client_name(client_name))
end

Given /^the client "([^"]+)" is disabled$/ do |client_name|
  client = OisClient.find_by_client_name client_name
  client.disabled = true
  client.save!
end

When /^I make a client request$/ do
  steps %{When I make an API GET request to "/api/v1/client/get-private-label"}
end

When /^I make a client request with the following headers:$/ do |headers|
  step "I make an API GET request to '/api/v1/client/get-private-label' with the following headers:", headers
end
