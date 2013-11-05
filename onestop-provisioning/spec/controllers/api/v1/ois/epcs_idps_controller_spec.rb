require 'spec_helper'

describe Api::V1::Ois::EpcsIdpsController do

  describe "GET 'verify_provider'" do
    it "I should be able to verify a provider" do
      get :verify_provider, format: :json, npi: "9632587412", first_name: "Asghar", last_name: "Mohiuddin"
      response_data = JSON.parse(response.body)
      response_data["ois_list"].first["ois_name"].present? == true
    end

    it "I should be able to get error message to verify a provider if proper parameters are not provided" do
      get :verify_provider, format: :json, npi: "845136445", first_name: "testfname", last_name: "testlname"
      response_data = JSON.parse(response.body)
      response_data["status"].should == 404
    end
  end

  describe "POST 'save_provider'" do
   it "I should be able to save a provider" do
     post :save_provider, format: :json, npi: "5896365212", first_name: "testfname", last_name: "testlname"
     response_data = JSON.parse(response.body)
     response_data['status'].should == "ok"
   end

   it "I should be able to see warning message while saving a provider if proper information is not provided" do
     post :save_provider, format: :json, npi: "5896547856", first_name: "1tfname", last_name: "testlname"
     response_data = JSON.parse(response.body)
     response_data['status'].should == 500
   end
  end
end
