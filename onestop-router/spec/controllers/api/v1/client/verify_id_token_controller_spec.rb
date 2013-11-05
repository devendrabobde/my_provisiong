require 'spec_helper'

describe Api::V1::Client::VerifyIdTokenController do
  render_views

  before do
    @user                               = FactoryGirl.create(:user)
    @ois                                = FactoryGirl.create(:ois)
    @ois_user_token                     = FactoryGirl.create(:ois_user_token)
    @ois_client                         = FactoryGirl.create(:ois_client)

    @ois_client.client_name             = "Reenhanced LLC"
    @ois_client.client_password         = "12345678911234567892123456789312345678941234567895"
    @ois_client.save

    @ois.ois_name                       = "RamboMD"
    @ois.enrollment_url                 = "http://rambomd.com/signup"
    @ois.idp_level                      = 1

    @user.npi                           = "1234567890"
    @user.first_name                    = "Carlos"
    @user.last_name                     = "Casteneda"

    @ois_user_token.token               = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx65"

    @ois_user_token.user                = @user
    @ois_user_token.ois                 = @ois

    @user.oises << @ois

    @ois_user_token.save
    @user.save
    @ois.save

    request.env['HTTP_CLIENTID']        = @ois_client.client_name
    request.env['HTTP_CLIENTPASSWORD']  = @ois_client.client_password
  end

  describe "a valid client makes a get request to 'verify-id-token'" do
    before do
      get 'show', token: @ois_user_token.token
    end
    specify "the correct JSON response" do
      json_response = JSON(response.body)
      json_response["first_name"].should  == @user.first_name
      json_response["idp_level"].should   == @ois.idp_level
      json_response["last_name"].should   == @user.last_name
      json_response["npi"].should         == @user.npi
    end
  end

  describe "a valid client makes a get request to 'verify-id-token' without a token" do
    before do
      get 'show'
    end
    specify "the correct JSON response" do
      error_code_message_response("invalid-request", "Token is required")
    end
  end

  describe "a valid client makes a get request to 'verify-id-token' with a non-existent token" do
    before do
      get 'show', token: "333xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx65"
    end
    specify "the correct JSON response" do
      error_code_message_response("not-found", "Token not found")
    end
  end

  describe "a valid client makes a get request to 'verify-id-token' with an expired token" do
    before do
      @ois_user_token.createddate = 2.months.ago
      @ois_user_token.token       = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx75"
      @ois_user_token.user        = @user
      @ois_user_token.ois         = @ois
      @ois_user_token.save
      get 'show', token: @ois_user_token.token
    end
    specify "the correct JSON response" do
      error_code_message_response("expired-id-token", "Token expired")
    end
  end

  describe "a valid client makes a get request to 'verify-id-token' with a token that has already been verified" do
    before do
      @ois_user_token.verified_timestamp  = 5.minutes.ago
      @ois_user_token.createddate         = 1.hour.ago
      @ois_user_token.token               = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx60"
      @ois_user_token.user                = @user
      @ois_user_token.ois                 = @ois
      @ois_user_token.save
      get 'show', token: @ois_user_token.token
    end
    specify "the correct JSON response" do
      error_code_message_response("verified-id-token", "Token previously used for validation")
    end
  end
end
