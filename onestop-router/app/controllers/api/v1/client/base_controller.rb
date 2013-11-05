class Api::V1::Client::BaseController < Api::V1::BaseController
  before_filter :authenticate_client

  def client
    @client
  end

  def current_user
    client
  end

  def set_client_id
    env['client_id'] = client.id
  end

  protected
    def min_idp_level
      params['min_idp_level']
    end

    def ois_id
      params['ois_id']
    end

  private
    def authenticate_client
      client_email    = request.headers['HTTP_CLIENTID']
      client_password = request.headers.delete('HTTP_CLIENTPASSWORD')

      @client = ::OisClient.authenticate(client_email, client_password)
    end
end
