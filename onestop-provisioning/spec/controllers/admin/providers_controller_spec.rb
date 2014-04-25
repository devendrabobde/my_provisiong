require 'spec_helper'
require 'csv'

describe Admin::ProvidersController do
  before(:each) do
    @request.env["devise.mapping"]  = Devise.mappings[:cao]
    @cao                            = FactoryGirl.create(:cao)
    @role                           = FactoryGirl.create(:role, name: "COA")
    @organization                   = FactoryGirl.create(:organization)
    @cao.update_attributes(fk_role_id: @role.id, fk_organization_id: @organization.id)
    @old_password                   = OldPassword.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: @cao.id)
    @cao.old_passwords              << @old_password
    @audit_trail                    = FactoryGirl.create(:audit_trail)
    @registered_app                 = RegisteredApp.where(app_name: "EPCS-IDP").first
    @audit_trail.update_attributes(fk_organization_id: @organization.id, fk_registered_app_id: @registered_app.id)
    sign_in @cao
  end

  describe "GET 'application'" do

    it "As a logged in coa, I should be able to see application and audit trail information" do
      get :application, format: :js, registered_app_id: ""
      response.should be_success
      response.status.should == 200
      response.should render_template('/admin/providers/_audit_trail_list', format: :js)
    end

    it "As a logged in coa, I should be able to see application and audit trail information with registered app id provided" do
      get :application, format: :js, registered_app_id: @registered_app.id
      response.should be_success
      response.status.should == 200
      response.should render_template('/admin/providers/_audit_trail_list', format: :js)
    end

  end

  describe "GET #show" do

    it "As a logged in coa, I should be able to see uploaded provider list" do
      get :show, format: :html, id: @audit_trail.id
      response.should be_success
    end
    
  end

  describe "GET #download" do

    it "As a logged in coa, I should be able to download csv file of all providers when audit id is provied" do
      get :download, format: :csv, id: @audit_trail.id, audit_id: @audit_trail.id
      response.should be_success
    end

    it "As a logged in coa, I should be able to download csv file of all providers when registered app id is provided for EPCS-IDP application" do
      get :download, format: :csv, id: @registered_app.id
      response.should be_success
    end

    it "As a logged in coa, I should be able to download csv file of all providers when registered app id is provided for Rcopia application" do
      registered_app = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["RCOPIA"]).first
      get :download, format: :csv, id: registered_app.id
      response.should be_success
    end

    it "As a logged in coa, I should be able to download csv file of all providers when registered app id is provided for Moxy application" do
      registered_app = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["MOXY"]).first
      get :download, format: :csv, id: registered_app.id
      response.should be_success
    end

    it "As a logged in coa, I should be able to download csv file of all providers when registered app id is provided for Backline application" do
      registered_app = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["BACKLINE"]).first
      get :download, format: :csv, id: registered_app.id
      response.should be_success
    end
    
  end

  describe "GET #download_sample_file" do
    it "As a logged in coa, I should be able to download a sample csv file for EPCS-IDP application" do
      get :download_sample_file, format: :csv, id: @registered_app.id
      response.should be_success
    end
    it "As a logged in coa, I should be able to download a sample csv file for EPCS-IDP application" do
      reg_app_moxy = RegisteredApp.where(app_name: "Moxy").first
      get :download_sample_file, format: :csv, id: reg_app_moxy.id
      response.should be_success
    end
    it "As a logged in coa, I should be able to download a sample csv file for EPCS-IDP application" do
      reg_app_rcopia = RegisteredApp.where(app_name: "Rcopia").first
      get :download_sample_file, format: :csv, id: reg_app_rcopia.id
      response.should be_success
    end
  end

  describe "POST #upload" do

    describe "EPCS UI validation fails test cases" do

      it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with required fields are missing (e.g. first name) then I should be able to see a error message", js: true do
        post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_missing_required_field.csv")
        response.should redirect_to application_admin_providers_path(registered_app_id: @registered_app.id)
        response.status.should == 302
      end

      it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with missing multiple required fields (e.g. first name, npi) then I should be able to see a error message" do
        post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_missing_multiple_required_fields.csv")
        response.should redirect_to application_admin_providers_path(registered_app_id: @registered_app.id)
        response.status.should == 302
      end

      it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with only the NPI is duplicated then file should be rejected and I should be able to see a proper error message" do
        post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_duplicate_npi_provider_record.csv")
        response.should redirect_to application_admin_providers_path(registered_app_id: @registered_app.id)
        response.status.should == 302
      end

    end

  end
  
end
