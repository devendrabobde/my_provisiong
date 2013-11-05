require 'test_helper'
require 'rails/performance_test_help'

class ApiVerifyIdTokenPerformanceTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 100, :metrics => [:wall_time],
                           :output => 'tmp/performance', :formats => [:flat] }

  def setup
    @client = FactoryGirl.create(:ois_client)
    2.times do
      ois = FactoryGirl.create(:ois)
      user = FactoryGirl.create(:user)
      user.oises << Ois.all
      id_token = ois.ois_user_tokens.build
      id_token.user = user
      id_token.save!
    end
  end

  def client_headers
    {
      "HTTP_CLIENTID"       => @client.slug,
      "HTTP_CLIENTPASSWORD" => @client.client_password
    }
  end

  def token_params
    token = OisUserToken.all.sample

    { :token => token.token }
  end

  def test_verify_id_token
    get '/api/v1/client/verify-id-token.json', token_params, client_headers
  end
end
