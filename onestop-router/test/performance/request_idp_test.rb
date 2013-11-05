require 'test_helper'
require 'rails/performance_test_help'

class ApiRequestIdpPerformanceTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 100, :metrics => [:wall_time],
                           :output => 'tmp/performance', :formats => [:flat] }

  def setup
    @client = FactoryGirl.create(:ois_client)
    2.times do
      FactoryGirl.create(:ois)
      user = FactoryGirl.create(:user)
      user.oises << Ois.all
    end
  end

  def client_headers
    {
      "HTTP_CLIENTID"       => @client.slug,
      "HTTP_CLIENTPASSWORD" => @client.client_password
    }
  end

  def user_params
    user = User.all.sample

    { :npi => user.npi, :first_name => user.first_name, :last_name => user.last_name }
  end

  def test_request_idp
    get '/api/v1/client/request-idp.json', user_params, client_headers
  end
end
