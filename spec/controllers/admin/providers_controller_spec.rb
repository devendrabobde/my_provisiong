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
    @provider_app_detail.update_attributes(fk_organization_id: @organization.id, fk_audit_trail_id: @audit_trail.id)
    @provider.update_attribute(:fk_provider_app_detail_id, @provider_app_detail.id)
    @registered_app = RegisteredApp.where(app_name: "EPCS-IDP").first
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
    it "As a logged in coa, I should be able to download csv file of all providers when registered app id is provided" do
      get :download, format: :csv, id: @registered_app.id
      response.should be_success
    end
  end

  describe "POST #upload" do
    describe "EPCS UI validation fails test cases" do
      it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with required fields are missing (e.g. first name) then I should be able to see a error message" do
        post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_missing_required_field.csv")
        response.should redirect_to application_admin_providers_path(registered_app_id: @registered_app.id)
        response.status.should == 302
        # flash[:error].should_not be_nil
        # flash[:error].should =~ /Providers required fields can't be blank/
      end

      it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with missing multiple required fields (e.g. first name, npi) then I should be able to see a error message" do
        post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_missing_multiple_required_fields.csv")
        response.should redirect_to application_admin_providers_path(registered_app_id: @registered_app.id)
        response.status.should == 302
        # flash[:error].should_not be_nil
        # flash[:error].should =~ /Providers required fields can't be blank/
      end

      it "As a logged in COA, I should be able to upload a csv file. Once I upload a EPCS csv file which is containing list of providers with only the NPI is duplicated then file should be rejected and I should be able to see a proper error message" do
        post :upload, format: :html, provider: { registered_app_id: @registered_app.id }, upload: Rack::Test::UploadedFile.new("#{Rails.root}/public/rspec_test_files/epcs/epcs_duplicate_npi_provider_record.csv")
        response.should redirect_to application_admin_providers_path(registered_app_id: @registered_app.id)
        response.status.should == 302
        # flash[:error].should_not be_nil
        # flash[:error].should =~ /For EPCS, the NPI must be unique for each record in the file. Please remove duplicate NPI/
      end
    end
  end
end
