require 'spec_helper'

describe Api::V1::Ois::UsersController do

  before do
    @ois                            = FactoryGirl.create(:ois)
    @ois.ois_name                   = "DFID"
    @ois.idp_level                  = 1
    @ois.ois_password               = "12345678911234567892123456789312345678941234567895"
    @ois.enrollment_url             = "http://rambomd.com/login"

    @user                           = FactoryGirl.create(:user)
    @user.npi                       = "1234567890"
    @user.first_name                = "Carlos"
    @user.last_name                 = "Casteneda"
    @user.enabled                   = true

    @ois.save

    request.env['HTTP_OISID']       = @ois.slug
    request.env['HTTP_OISPASSWORD'] = @ois.ois_password
  end

  describe "OIS makes POST request to 'save-user' for a new user" do
    before do
      @user.enabled = false
      post 'create', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name
    end
    specify "the created user" do
      @ois.users.size.should          == 1
      @ois.users[0].npi.should        == @user.npi
      @ois.users[0].first_name.should == @user.first_name
      @ois.users[0].last_name.should  == @user.last_name
      @ois.users[0].enabled.should       be_true
    end
    specify "the 'ok' staus code" do
      response.response_code.should == 200
    end
    specify "that the created user be modified" do
      @ois.users[0].enabled.should be_true
    end
  end

  describe "OIS makes POST request to 'save-user' for an existing user" do
    before do
      @user.npi         = "1234567890"
      @user.first_name  = "Joey"
      @user.last_name   = "Bagofdonuts"
      @user.enabled     = true
      @user.save
      post 'create', npi: "1234567890", first_name: "Carlos", last_name: "Casteneda", enabled: false
    end
    specify "the created user" do
      @ois.users.size.should          == 1
      @ois.users[0].npi.should        == "1234567890"
      @ois.users[0].first_name.should == "Carlos"
      @ois.users[0].last_name.should  == "Casteneda"
      @ois.users[0].enabled.should    be_false
    end
  end

  describe "OIS makes POST request to 'save-user' with invalid user data" do
    context "missing npi" do
      before do
        post 'create', npi: nil, first_name: "Carlos", last_name: "Casteneda"
      end
      specify "the correct JSON response" do
        error_code_message_response("invalid-user", "Npi is invalid")
      end
    end
    context "missing first_name" do
      before do
        post 'create', npi: "1234567890", first_name: nil, last_name: "Casteneda"
      end
      specify "the correct JSON response" do
        error_code_message_response("invalid-user", "First name is invalid")
      end
    end
    context "missing last_name" do
      before do
        post 'create', npi: "1234567890", first_name: "Carlos", last_name: nil
      end
      specify "the correct JSON response" do
        error_code_message_response("invalid-user", "Last name is invalid")
      end
    end
    context "missing npi, first_name and last_name" do
      before do
        post 'create', npi: nil, first_name: nil, last_name: nil
      end
      specify "the correct JSON response" do
        error_code_message_response("invalid-user", "First name is invalid,Last name is invalid,Npi is invalid")
      end
    end
  end

  describe "ois makes a valid save-user request" do
    before do
      post 'create', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, enabled: @user.enabled
    end
    specify "the success header values" do
      response.response_code.should               == 200
      response.headers["ResponseStatus"].should == "success"
      response.headers["ErrorCategory"].should  == "request"
      response.headers["ErrorCode"].should          be_blank
      response.headers["ErrorMessage"].should       be_blank
    end
    specify "the JSON 'ok' status" do
      json_response                   = JSON(response.body)
      json_response["status"].should  == "ok"
    end
  end

  describe "ois makes a request using invalid credentials" do
    before do
      request.env['HTTP_OISPASSWORD']   = "22222222222222222222222222222222222222222222222222"
      post 'create', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, enabled: @user.enabled
    end
    it_should_behave_like "a failed ois login"
  end

  describe "login a disabled ois" do
    before do
      @ois.disabled = true
      @ois.save
      post 'create', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, enabled: @user.enabled
    end
    it_should_behave_like "a failed ois login"
  end
end
