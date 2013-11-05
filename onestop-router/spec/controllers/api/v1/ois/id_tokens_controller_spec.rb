require 'spec_helper'

describe Api::V1::Ois::IdTokensController do
  render_views

  before do
    @user                 = FactoryGirl.create(:user)
    @ois                  = FactoryGirl.create(:ois)

    @ois.ois_name         = "RamboMD"
    @ois.idp_level        = 1

    @user.npi             = "1234567890"
    @user.first_name      = "Carlos"
    @user.last_name       = "Casteneda"

    @user.oises << @ois

    @ois.save
    @user.save
  end

  describe "ois makes a valid create-id-token request" do
    before do
      request.env['HTTP_OISID']         = @ois.slug
      request.env['HTTP_OISPASSWORD']   = @ois.ois_password
      post 'create', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, idp_level: 1
    end
    specify "the correct JSON response with the token for NPI '1234567890'" do
      @user.oises.size.should                     == 1
      @user.oises[0].ois_user_tokens.size.should  == 1
      json_response                               = JSON(response.body)
      json_response["id_token"].should            ==  @user.oises[0].ois_user_tokens[0].token
    end
  end

  describe "ois makes a post request with missing data" do
    before do
      request.env['HTTP_OISID']         = @ois.slug
      request.env['HTTP_OISPASSWORD']   = @ois.ois_password
      post 'create', npi: @user.npi
    end
    specify "the correct JSON response" do
      error_code_message_response("invalid-request", "Invalid User Request")
    end
  end

  describe "ois makes a post request with invalid user data" do
    before do
      request.env['HTTP_OISID']         = @ois.slug
      request.env['HTTP_OISPASSWORD']   = @ois.ois_password
    end
    context "incorrect npi" do
      before do
        post 'create', npi: "1231231230", first_name: @user.first_name, last_name: @user.last_name, idp_level: 1
      end
      specify "the correct JSON response" do
        error_code_message_response("not-found", "User not found")
      end
    end
    context "incorrect first_name" do
      before do
        post 'create', npi: @user.npi, first_name: "Greatest", last_name: @user.last_name, idp_level: 1
      end
      specify "the correct JSON response" do
        error_code_message_response("npi-name-mismatch", "NPI Name Mismatch")
      end
    end
    context "incorrect last_name" do
      before do
        post 'create', npi: @user.npi, first_name: @user.first_name, last_name: "Ever", idp_level: 1
      end
      specify "the correct JSON response" do
        error_code_message_response("npi-name-mismatch", "NPI Name Mismatch")
      end
    end
    context "incorrect idp_level" do
      before do
        post 'create', npi: @user.npi, first_name: @user.first_name, last_name: @user.last_name, idp_level: 4
      end
      specify "the correct JSON response" do
        error_code_message_response("invalid-id-token", "IDP level does not match")
      end
    end
  end
end
