require 'spec_helper'
require 'csv'

describe Admin::OrganizationsController do

  before(:each) do
    @request.env["devise.mapping"]  = Devise.mappings[:cao]
    @cao                            = FactoryGirl.create(:cao)
    @role                           = FactoryGirl.create(:role, name: "Admin")
    @organization                   = FactoryGirl.create(:organization)
    @cao.update_attributes(fk_role_id: @role.id, fk_organization_id: @organization.id)
    @provider                       = FactoryGirl.create(:provider)
    sign_in @cao
  end

  describe "Super Admin Test Cases" do

    it "As a logged in Super Admin, I should be able to view organization" do
      get :show, format: :html, id: @organization.id
      response.should be_success
    end

    it "As a logged in Super Admin, I should be able to view all organizations" do
      get :index, format: :html
      response.should be_success
    end

    it "As a logged in Super Admin, I should be able to see form to create an organization" do
      get :new, format: :html
      response.should be_success
    end

    it "As a logged in Super Admin, I should be able to edit an organization" do
      get :edit, format: :html, id: @organization.id
      response.should be_success
    end

    describe "Add new organization" do
      before(:each) do
        @org_data = { name: Faker::Name.name, address1: Faker::Address.street_address,
                      address2: Faker::Address.secondary_address, city: Faker::Address.city,
                      state_code: Faker::Address.state, zip_code: "12345",
                      contact_first_name: Faker::Name.first_name, contact_last_name: Faker::Name.last_name,
                      contact_phone: "890-908-3067", contact_fax: 59874521, contact_email: Faker::Internet.email,
                      idp_vendor_id: "idptestid"
                    }

        @invalid_org_data = { name: Faker::Name.name, address1: Faker::Address.street_address,
                              address2: Faker::Address.secondary_address, city: Faker::Address.city,
                              state_code: Faker::Address.state, zip_code: "12345",
                              contact_first_name: "AB111ww3", contact_last_name: Faker::Name.last_name,
                              contact_phone: "890-908-3067", contact_fax: 59874521, contact_email: Faker::Internet.email,
                              idp_vendor_id: "idptestid"
                            }
      end

      it "As a logged in Super Admin, I should be able to add new organization" do
        post :create, format: :html, organization: @org_data
        response.status.should == 302
      end

      it "As a logged in Super Admin, I should be able to see error message while creating an organization" do
        post :create, format: :html, organization: @invalid_org_data
        response.status.should == 200
      end

    end

    describe "Update organization" do

      before(:each) do
        @org_data = { name: Faker::Name.name, address1: Faker::Address.street_address,
          address2: Faker::Address.secondary_address, city: Faker::Address.city,
          state_code: Faker::Address.state, zip_code: "12345",
          contact_first_name: Faker::Name.first_name, contact_last_name: Faker::Name.last_name,
          contact_phone: "890-908-3067",
          contact_fax: 59874521, contact_email: Faker::Internet.email,
          idp_vendor_id: "idptestid" }

        @invalid_org_data = { name: Faker::Name.name, address1: Faker::Address.street_address,
          address2: Faker::Address.secondary_address, city: Faker::Address.city,
          state_code: Faker::Address.state, zip_code: "12345",
          contact_first_name: "AB111ww3", contact_last_name: Faker::Name.last_name,
          contact_phone: "890-908-3067",
          contact_fax: 59874521, contact_email: Faker::Internet.email,
          idp_vendor_id: "idptestid" }
      end

      it "As a logged in Super Admin, I should be able to update organization" do
        get :update, format: :html, id: @organization.id, organization: @org_data
        response.status.should == 302
        response.should redirect_to(admin_organization_path(@organization.id))
      end

      it "As a logged in onestop admin, I should be able to see error message while update an organization" do
        get :update, format: :html, id: @organization.id, organization: @invalid_org_data
        response.status.should == 200
      end

    end

    it "As a logged in Super Admin, I should be able to delete organization" do
      get :destroy, format: :html, id: @organization.id, organization: { deleted_reason: "test" }
      response.status.should == 302
    end

    it "As a logged in Super Admin, I should be able to activate organization" do
      post :activate, format: :html, id: @organization.id
      response.status.should == 302
    end

    describe "Audits upload history" do
      it "As a logged in Super Admin, I should be able to view any previously uploaded csv and its providers" do
        get :show_uploaded_file, format: :html, id: @organization.id
        response.status.should == 200
      end
      it "As a logged in Super Admin, I should be able to view any previously uploaded csv and its providers for a application" do
        registered_app = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
        get :show_uploaded_file, format: :js, id: @organization.id, registered_app_id: registered_app.id
        response.status.should == 200
      end
    end

    describe "#show_provider" do
      it "As a logged in Super Admin, I should be able to get a list of all providers for a particular organization and COA" do
        audit_trail = FactoryGirl.create(:audit_trail)
        get :show_provider, format: :html, id: audit_trail.id
        assert response.should be_true
      end
    end

    describe "#download_provider" do
      it "As a logged in Super Admin, I should be able to Download the list of providers in CSV format." do
        registered_app = FactoryGirl.create(:registered_app)
        audit_trail = FactoryGirl.create(:audit_trail, fk_registered_app_id: registered_app.id)
        get :download_provider, format: :csv, id: audit_trail.id, audit_id: audit_trail.id
        assert response.should be_true
      end
    end

  end
end
