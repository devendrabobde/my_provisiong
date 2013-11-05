require 'spec_helper'
require 'csv'

describe Admin::ProvidersController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:cao]
    @cao = FactoryGirl.create(:cao)
    @role = FactoryGirl.create(:role, name: "COA")
    @organization = FactoryGirl.create(:organization)
    @cao.update_attributes(fk_role_id: @role.id, fk_organization_id: @organization.id)
    @provider = FactoryGirl.create(:provider)
    @provider_app_detail = FactoryGirl.create(:provider_app_detail)
    @audit_trail = FactoryGirl.create(:audit_trail)

    # @registered_app = FactoryGirl.create(:registered_app)
    # @audit_trail.update_attributes(fk_organization_id: @organization.id, fk_registered_app_id: @registered_app.id)

    @provider_app_detail.update_attributes(fk_organization_id: @organization.id, fk_audit_trail_id: @audit_trail.id)
    @provider.update_attribute(:fk_provider_app_detail_id, @provider_app_detail.id)

    # @epcs_application = RegisteredApp.where(app_name: "EPCS-IDP").first
    @registered_app = RegisteredApp.where(app_name: "EPCS-IDP").first
    # @registered_app = FactoryGirl.create(:registered_app)
    @audit_trail.update_attributes(fk_organization_id: @organization.id, fk_registered_app_id: @registered_app.id)
    sign_in @cao
  end

  describe "GET 'application'" do
    it "As a logged in coa, I should be able to see application and audit trail information" do
      get :application, format: :js, registered_app_id: ""
      # xhr :get, :application, registered_app_id: ""
      response.should be_success
      response.status.should == 200
      response.should render_template('/admin/providers/_audit_trail_list', format: :js)
    end

    it "As a logged in coa, I should be able to see application and audit trail information with registered app id provided" do
      get :application, format: :js, registered_app_id: @registered_app.id
      # xhr :get, :application, registered_app_id: @registered_app.id
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
    it "As a logged in coa, I should be able to download csv file of all providers when registered app id is provided" do
      get :download, format: :csv, id: @registered_app.id
      response.should be_success
    end
  end

  describe "POST #upload" do
    it "As a logged in COA, I should be able to upload csv file" do
      post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_valid.csv")
      response.should redirect_to application_admin_providers_path
      response.status.should == 302
    end
    it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with some required fields are missing then I should be able to see a error message" do
      post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_invalid.csv")
      response.should redirect_to application_admin_providers_path
      response.status.should == 302
      flash[:error].should_not be_nil
    end
    it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with valid data then I should be able to see a success message" do
      post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_valid.csv")
      response.should redirect_to application_admin_providers_path
      response.status.should == 302
      flash[:notice].should_not be_nil
    end
  end
end
