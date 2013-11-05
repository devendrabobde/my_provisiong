class Api::V1::Client::PrivateLabelsController < Api::V1::Client::BaseController
  def show
    @ois_client_preference = @client.try(:ois_client_preference) || OisClientPreference.default
    success_with @ois_client_preference
  end
end
