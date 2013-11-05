Given "the default client preference exists" do
  create(:default_ois_client_preference) unless OisClientPreference.default.present?
end
