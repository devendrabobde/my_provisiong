class Api::V1::Client::VerifyIdentityController < Api::V1::Client::BaseController
  def index
    @user = User.find_by_request(user_params)
    @oises = @user.oises.order("createddate ASC")
    @oises = @oises.with_min_idp_level(min_idp_level) if min_idp_level.present?
    @oises = [@oises.find(ois_id)] if ois_id.present?

    success_with(@oises)
  end
end
