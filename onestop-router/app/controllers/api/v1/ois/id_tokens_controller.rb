class Api::V1::Ois::IdTokensController < Api::V1::Ois::BaseController
  def create
    @user     = @ois.users.find_by_request(user_params)
    @id_token = @ois.ois_user_tokens.build

    @id_token.user = @user

    if params[:idp_level].to_i != @id_token.idp_level
      raise OisUserToken::Invalid.new(message: "IDP level does not match")
    end

    begin
      @id_token.save!
      success_with(@id_token)
    rescue ActiveRecord::RecordInvalid => invalid_error
      raise OisUserToken::Invalid.new(message: @id_token.errors.full_messages.join(','))
    end
  end
end
