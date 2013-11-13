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

  def batch_upload
    invalid_users,valid_users = [],[]
    if params["users"].present?
      params["users"].each do |user|
        if user.present?
          @user = User.find_by_npi(user[:npi]) || User.new(user)
           # save_or_update_user!
           status = save_or_update(user)
          unless status
            key =  user["first_name"] + " " + user["last_name"]
            errors = { key => @user.errors.full_messages.join(',') }
            invalid_users << errors
          else
            key = user["first_name"] + " " + user["last_name"]
            valid_users << key
          end
        end
      end
    end
    request_successful
    render :json => {:status => :ok, :invalid_users => invalid_users, :valid_users => valid_users }.to_json
  end

  def save_provider
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

    def save_or_update(user)
      @user.oises |= [@ois]

      if @user.new_record?
        @user.save
      else
        @user.update_attributes(user)
      end
    end
end