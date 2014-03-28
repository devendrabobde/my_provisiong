require 'spec_helper'
require 'csv'

describe Admin::CaosController do
  
  before(:each) do
    @request.env["devise.mapping"]  = Devise.mappings[:cao]
    @cao                            = FactoryGirl.create(:cao)
    @role                           = FactoryGirl.create(:role, name: "Admin")
    @organization                   = FactoryGirl.create(:organization)
    @cao.update_attributes(fk_role_id: @role.id, fk_organization_id: @organization.id)
    @provider                       = FactoryGirl.create(:provider)
    @profile                        = FactoryGirl.create(:profile)
    @role1                          = FactoryGirl.create(:role, name: "COA")
    sign_in @cao
  end

  describe "Super Admin Test Cases" do

    it "As a logged in Super Admin, I should be able to see form to create a new COA" do
      get :new, format: :html, organization_id: @organization.id
      response.should be_success
    end

    it "As a logged in Super Admin, I should be able to edit a COA" do
      get :edit, format: :html, id: @cao.id, organization_id: @organization.id
      response.should be_success
    end

    describe "Add new COA" do

      before(:each) do
        @coa1_data = { user_id: Faker::Internet.slug, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, is_active: true, email: Faker::Internet.email, password: "password", password_confirmation: "password", username: Faker::Internet.user_name }
        @coa2_data = { user_id: Faker::Internet.slug, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, is_active: true, email: Faker::Internet.email, password: "password", password_confirmation: "password", username: Faker::Internet.user_name }
        @invalid_coa_data = { user_id: Faker::Internet.slug, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, is_active: true, email: "test...", password: "password", password_confirmation: "password", username: Faker::Internet.user_name }
      end

      it "As a logged in Super Admin, I should be able to create a new COA" do
        post :create, format: :html, organization_id: @organization.id, cao: @coa1_data
        response.status.should == 302
      end

      it "As a logged in Super Admin, I should be able see error message while creating a new COA" do
        post :create, format: :html, organization_id: @organization.id, cao: @invalid_coa_data
        response.status.should == 200
      end

      it "As a logged in Super Admin, I should be able to Super Admin to add a second COA to an organization" do
        post :create, format: :html, organization_id: @organization.id, cao: @coa2_data
        response.status.should == 302
      end
      
    end

    describe "Update COA" do

      before(:each) do
        @coa1_data = { user_id: Faker::Internet.slug, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, is_active: true, email: Faker::Internet.email, password: "password", password_confirmation: "password", username: Faker::Internet.user_name }
        @invalid_coa_data = { user_id: Faker::Internet.slug, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, is_active: true, email: "test...", password: "password", password_confirmation: "password", username: Faker::Internet.user_name }
      end

      it "As a logged in Super Admin, I should be able to update details of a COA" do
        put :update, format: :html, id: @cao.id, organization_id: @organization.id, cao: @coa1_data
        response.status.should == 302
      end

      it "As a logged in Super Admin, I should be able to see error message while updating details of a COA" do
        put :update, format: :html, id: @cao.id, organization_id: @organization.id, cao: @invalid_coa_data
        response.status.should == 200
      end
      
    end

    it "As a logged in Super Admin, I should be able to select an organization" do
      post :index, format: :html, organization_id: @organization.id
      response.should be_success
    end

    it "As a logged in Super Admin, I should be able to delete a COA" do
      delete :destroy, format: :html, id: @cao.id, organization_id: @organization.id, cao: { deleted_reason: "test" }
      response.status.should == 302
    end

    it "As a logged in Super Admin, I should be able to view a COA" do
      get :show, format: :html, id: @cao.id, organization_id: @organization.id
      response.should be_success
    end

    it "As a logged in Super Admin, I should be able to activate a COA" do
      post :activate, format: :html, id: @cao.id, organization_id: @organization.id
      response.status.should == 302
    end

    it "As a logged in Super Admin, I should be able to view all COA in an organization" do
      post :index, format: :html, organization_id: @organization.id
      response.should be_success
    end

  end
  
end
