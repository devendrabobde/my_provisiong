class Api::V1::Ois::UsersController < Api::V1::Ois::BaseController
  def create
    @user = User.find_by_npi(user_params[:npi]) || User.new(user_params)

    begin
      save_or_update_user!
      request_successful
      render :json => {:status => :ok}.to_json
    rescue ActiveRecord::RecordInvalid => invalid_error
      raise User::Invalid.new(message: @user.errors.full_messages.join(','))
    end
  end

  private
    def save_or_update_user!
      @user.oises |= [@ois]

      if @user.new_record?
        @user.save!
      else
        @user.update_attributes!(user_params)
      end
    end
end
