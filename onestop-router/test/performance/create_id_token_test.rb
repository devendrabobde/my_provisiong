require 'test_helper'
require 'rails/performance_test_help'

class ApiCreateIdTokenPerformanceTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 100, :metrics => [:wall_time],
                           :output => 'tmp/performance', :formats => [:flat] }

  def setup
    @ois = FactoryGirl.create(:ois)
    2.times do
      FactoryGirl.create(:ois)
      user = FactoryGirl.create(:user)
      user.oises << Ois.all
    end
  end

  def ois_headers
    {
      "HTTP_OISID"       => @ois.slug,
      "HTTP_OISPASSWORD" => @ois.ois_password
    }
  end

  def user_params
    user = User.all.sample

    { :npi => user.npi, :first_name => user.first_name, :last_name => user.last_name, :idp_level => @ois.idp_level }
  end

  def test_create_id_token
    post '/api/v1/ois/create-id-token.json', user_params, ois_headers
  end
end
