class Api::V1::Client::ViewUserController < Api::V1::Client::BaseController
  def index
    @user  = User.find_by_npi!(user_params[:npi])
    @oises = @user.oises.order("createddate ASC")
    @oises = [@oises.find(ois_id)] if ois_id.present?

    @user_details = @oises.collect {|ois| ois.view_user(@user)}

    request_successful
    render :json => @user_details.to_json
  end
end
