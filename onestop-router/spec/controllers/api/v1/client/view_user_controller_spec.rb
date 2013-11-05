require 'spec_helper'

describe Api::V1::Client::ViewUserController do

  before do
    @user                               = FactoryGirl.create(:user)
    @ois_1                              = FactoryGirl.create(:ois)
    @organization                       = FactoryGirl.create(:organization)
    @ois_client                         = FactoryGirl.create(:ois_client)

    @ois_client.client_name             = "carlos.casteneda"
    @ois_client.client_password         = "12345678911234567892123456789312345678941234567895"
    @ois_client.save

    @ois_1.ois_name                     = "RamboMD"
    @ois_1.enrollment_url               = "http://rambomd.com/signup"
    @ois_1.idp_level                    = 1

    @organization.organization_name     = "Reenhanced LLC"
    @organization.address1              = "address1"
    @organization.address2              = "First Floor"
    @organization.city                  = "Quakertown"
    @organization.state_code            = "PA"
    @organization.postal_code           = "18951"
    @organization.country_code          = "USA"
    @organization.contact_first_name    = "Nicholas"
    @organization.contact_last_name     = "Hance"
    @organization.contact_phone         = "1 (866) 237-6836"
    @organization.contact_fax           = "(610) 886-3311"
    @organization.contact_email         = "nhance@reenhanced.com"
    @organization.organization_npi      = "1234567890"

    @ois_1.organization                 = @organization

    @user.npi                           = "1234567890"
    @user.first_name                    = "Carlos"
    @user.last_name                     = "Casteneda"

    @user.oises << @ois_1

    @user.save
    @ois_1.save

    @organization.save

    request.env['HTTP_CLIENTID']        = @ois_client.client_name
    request.env['HTTP_CLIENTPASSWORD']  = @ois_client.client_password
  end

  describe "a valid client makes a get request to 'view-user'" do
    before do
      @ois_2                            = FactoryGirl.create(:ois)
      @ois_2.ois_name                   = "FacebookMD"
      @ois_2.enrollment_url             = "http://facebook.com/signup"
      @ois_2.idp_level                  = 1
      @ois_2.organization               = @organization
      @user.oises << @ois_2
      @ois_2.save
      get 'index', npi: @user.npi
    end
    specify "the correct JSON response" do
      successful_organization_json_response(0, @user, @organization, @ois_1)
      successful_organization_json_response(1, @user, @organization, @ois_2)
    end
  end

  describe "a valid client makes a get request to 'view-user' with an ois_id or ois_slug" do
    context "with ois id" do
      before do
        get 'index', npi: @user.npi, ois_id: @ois_1.id
      end
      specify "the correct JSON response" do
        successful_organization_json_response(0, @user, @organization, @ois_1)
      end
    end
    context "with ois slug" do
      before do
        get 'index', npi: @user.npi, ois_id: @ois_1.slug
      end
      specify "the correct JSON response" do
        successful_organization_json_response(0, @user, @organization, @ois_1)
      end
    end
  end

  describe "a valid client makes a get request to 'view-user' without an NPI" do
    before do
      get 'index'
    end
    specify "the correct JSON response" do
      error_code_message_response("invalid-request", "Invalid User Request")
    end
  end
end
