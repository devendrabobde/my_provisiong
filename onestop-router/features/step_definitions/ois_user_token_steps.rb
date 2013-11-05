Given /^the user has the following ois user token:$/i do |table|
  @user ||= User.last
  @ois  ||= @user.oises.last

  raise "The user must have an OIS" unless @ois
  ois_params  = {ois_id: @ois.id, user_id: @user.id}

  @ois_user_token = create(:ois_user_token, ois_params.merge(table.rows_hash.symbolize_keys))
  @ois_user_token.token = table.rows_hash['token']
  @ois_user_token.createddate = table.rows_hash['createddate'] if table.rows_hash['createddate'].present?
  @ois_user_token.save!
end

Given /tokens are set to expire in ([0-9]+) ([a-zA-Z]+)$/ do |time_count, time_duration|
  @ois_user_token ||= OisUserToken.last
  token_expiration = time_count.to_i.send(time_duration.to_sym)
  @ois_user_token.stub(:server_configuration).and_return({ tokens_expire_in: token_expiration })
end

Then /^a ois user token should have been created for the user with npi "(.*)"$/i do |npi|
  user = User.find_by_npi(npi)
  @generated_id_token = OisUserToken.find_by_user_id(user.id)
  @generated_id_token.should be
  OisUserToken.last.should == @generated_id_token
end

Then /^the JSON response should contain the generated ois user token$/ do
  raise "No @generated_id_token found!  See features/step_definitions/id_token_steps.rb for usage" unless @generated_id_token.present?
  steps %{
    Then the JSON response should be:
      """
        {
          "id_token": "#{@generated_id_token.token}"
        }
      """
  }
end

Then /^the ois user token should be verified$/i do
  raise "No OisUserToken was setup.  Please see #{__FILE__} for how to do this." unless @ois_user_token
  @ois_user_token.reload
  @ois_user_token.verified_timestamp.should be
end
