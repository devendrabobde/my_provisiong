require 'spec_helper'

describe Api::V1::Ois::SupernpisController do

  describe "GET 'view_user'" do
    it "I should be able to veiw a provider information from Super NPI DB" do
      get :view_user, format: :json, npi_code: "9632587412"
      response_data = JSON.parse(response.body)
      response_data["status"].should == 200
    end

    it "I should not be able to see provider information from Super NPI DB" do
      get :view_user, format: :json, npi_code: "845136445"
      response_data = JSON.parse(response.body)
      response_data["status"].should == 404
    end
  end
end
