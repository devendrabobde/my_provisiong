require 'test_helper'
require 'rails/performance_test_help'

class ApiSaveUserPerformanceTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 100, :metrics => [:wall_time],
                           :output => 'tmp/performance', :formats => [:flat] }

  def setup
    @ois = FactoryGirl.create(:ois)
  end

  def ois_headers
    {
      "HTTP_OISID"       => @ois.slug,
      "HTTP_OISPASSWORD" => @ois.ois_password
    }
  end

  def user_params
    user = FactoryGirl.build(:user)

    { :npi => user.npi, :first_name => user.first_name, :last_name => user.last_name }
  end

  def test_save_user
    post '/api/v1/ois/save-user.json', user_params, ois_headers
  end
end
