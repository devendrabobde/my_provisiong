require 'spec_helper'

describe Api::V1::Client::RequestIdpController do
  render_views

  before do
    request_idp_precursor
    request.env['HTTP_CLIENTID']        = @ois_client.client_name
    request.env['HTTP_CLIENTPASSWORD']  = @ois_client.client_password
  end

  describe "a client makes a get request to 'request-idp' as a valid client" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name
    end
    specify "the correct JSON response" do
      successful_ois_json_response_enrollment(@ois_1)
      successful_ois_json_response_enrollment(@ois_2, 1)
    end
  end

  describe "a client makes a get request to 'request-idp' with an IDP level" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, min_idp_level: 2
    end
    specify "the correct JSON response" do
      successful_ois_json_response_enrollment(@ois_2)
    end
  end

  describe "a client makes a get request to 'request-idp' with an OIS id" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, ois_id: @ois_1.id
    end
    specify "the correct JSON response" do
      successful_ois_json_response_enrollment(@ois_1)
    end
  end

  describe "a client makes a get request to 'request-idp' with a non-existent NPI" do
    before do
      get 'index', npi: "1231231230", first_name: @user.first_name, last_name: @user.last_name
    end
    specify "the 'ok' staus code" do
      response.response_code.should == 200
    end
    specify "the correct JSON response" do
      error_code_message_response("not-found", "User not found")
    end
  end

  describe "a client makes a get request to 'request-idp' with invalid user data" do
    before do
      get 'index', npi: "1234567890", first_name: "Carlos", last_name: "Sanchez"
    end
    specify "the 'ok' staus code" do
      response.response_code.should == 200
    end
    specify "the correct JSON response" do
      error_code_message_response("npi-name-mismatch", "NPI Name Mismatch")
    end
  end
end
