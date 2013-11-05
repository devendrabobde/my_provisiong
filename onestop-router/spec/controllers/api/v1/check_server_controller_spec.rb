require 'spec_helper'

describe Api::V1::CheckServerController do
  render_views

  describe "make get request to the 'check-server' api to get system status" do
    specify "the correct JSON response" do
      get 'show'
      json_response = JSON(response.body)
      json_response["service_name"].should          == "OneStop Router"
      json_response["server_instance_name"].should  == "test"
      json_response["code_version"].should          == 1
      json_response["database_connection"].should   be_true
    end
  end
end
