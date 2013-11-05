require 'spec_helper'

describe Api::V1::Client::VerifyIdentityController do
  render_views

  before do
    verify_identity_precursor
    request.env['HTTP_CLIENTID']        = @ois_client.client_name
    request.env['HTTP_CLIENTPASSWORD']  = @ois_client.client_password
  end

  describe "a valid client makes a get request to 'verify-identity'" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name
    end
    specify "the correct JSON response" do
      successful_ois_json_response_authentication(@ois_1)
      successful_ois_json_response_authentication(@ois_2, 1)
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with a minimum IDP level" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, min_idp_level: 2
    end
    specify "the correct JSON response" do
      successful_ois_json_response_authentication(@ois_2)
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with an OIS id or slug" do
    context "make request with a an ois id" do
      before do
        get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, ois_id: @ois_1.id
      end
      specify "the correct JSON response" do
        successful_ois_json_response_authentication(@ois_1)
      end
    end
    context "make request with a slug" do
      before do
        get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, ois_id: @ois_2.slug
      end
      specify "the correct JSON response" do
        successful_ois_json_response_authentication(@ois_2)
      end
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with an OIS id or slug that does not exist" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, ois_id: "0000000000"
    end
    specify "the correct JSON response" do
      error_code_message_response("not-found", "Record not found")
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with an NPI that does not exist" do
    before do
      get 'index', npi: "1231231230", first_name: @user.first_name, last_name: @user.last_name
    end
    specify "the correct JSON response" do
      error_code_message_response("not-found", "User not found")
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with invalid user data" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name+"ww", last_name: @user.last_name+"ww"
    end
    specify "the correct JSON response" do
      error_code_message_response("npi-name-mismatch", "NPI Name Mismatch")
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with missing npi parameter" do
    before do
      get 'index', first_name: @user.first_name, last_name: @user.last_name
    end
    specify "the 'ok' staus code" do
      response.response_code.should == 200
    end
    specify "the correct JSON response" do
      error_code_message_response("invalid-request", "Invalid User Request")
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with missing first_name parameter" do
    before do
      get 'index', npi: @user.npi, last_name: @user.last_name
    end
    specify "the 'ok' staus code" do
      response.response_code.should == 200
    end
    specify "the correct JSON response" do
      error_code_message_response("invalid-request", "Invalid User Request")
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with missing last_name parameter" do
    before do
      get 'index', npi: @user.npi, first_name: @user.first_name
    end
    specify "the 'ok' staus code" do
      response.response_code.should == 200
    end
    specify "the correct JSON response" do
      error_code_message_response("invalid-request", "Invalid User Request")
    end
  end
end
