require 'spec_helper'

describe Api::V1::Client::PrivateLabelsController do
  render_views

  before do
    @ois_client                 = FactoryGirl.create(:ois_client)
    @ois_client.client_name     = "carlos.casteneda"
    @ois_client.client_password = "12345678911234567892123456789312345678941234567895"
    @ois_client.save
  end

  describe "client makes a valid request" do
    before do
      request.env['HTTP_CLIENTID']         = @ois_client.client_name
      request.env['HTTP_CLIENTPASSWORD']   = @ois_client.client_password
      get 'show'
    end
    specify "response success header values" do
      response.response_code.should               == 200
      response.headers["ResponseStatus"].should == "success"
      response.headers["ErrorCategory"].should  == "request"
      response.headers["ErrorCode"].should          be_blank
      response.headers["ErrorMessage"].should       be_blank
    end
  end

  describe "login a disabled client" do
    before do
      @ois_client.disabled = true
      @ois_client.save
      request.env['HTTP_CLIENTID']         = @ois_client.client_name
      request.env['HTTP_CLIENTPASSWORD']   = @ois_client.client_password
      get 'show'
    end
    it_should_behave_like "a failed client login"
  end

  describe "client makes a request using invalid credentials" do
    before do
      request.env['HTTP_CLIENTID']         = @ois_client.client_name
      request.env['HTTP_CLIENTPASSWORD']   = "11111111111111111111111111111111111111111111111111"
      get 'show'
    end
    it_should_behave_like "a failed client login"
  end

  describe "make request to 'get-private-label'" do
    before do
      @ois_client_preference              = FactoryGirl.create(:ois_client_preference)
      @ois_client_preference              = @ois_client.ois_client_preference
      @ois_client_preference.save
      request.env['HTTP_CLIENTID']        = @ois_client.client_name
      request.env['HTTP_CLIENTPASSWORD']  = @ois_client.client_password
      get 'show'
    end
    specify "correct JSON response" do
      json_response = JSON(response.body)
      json_response["client_name"].should       == @ois_client_preference.client_name
      json_response["created_date"].should      == @ois_client_preference.createddate.strftime("%Y-%m-%dT%H:%M:%SZ")
      json_response["faq_url"].should           == @ois_client_preference.faq_url
      json_response["help_url"].should          == @ois_client_preference.help_url
      json_response["logo_url"].should          == @ois_client_preference.logo_url
      json_response["preference_name"].should   == @ois_client_preference.preference_name
      json_response["last_update_date"].should  == @ois_client_preference.lastupdatedate.strftime("%Y-%m-%dT%H:%M:%SZ")
      json_response["slug"].should              == @ois_client_preference.slug
    end
  end

end
