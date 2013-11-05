class Api::V1::Client::VerifyIdTokenController < Api::V1::Client::BaseController
  def show
    begin
      @id_token = OisUserToken.verify_token!(id_token)
      success_with(@id_token)
    rescue ActiveRecord::RecordInvalid => invalid_error
      raise OisUserToken::Invalid.new(message: @id_token.errors.full_messages.join(','))
    end
  end

  protected
    def id_token
      params[:token]
    end
end
