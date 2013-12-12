require 'spec_helper'
require 'pry'

describe Devise::RegistrationsController do
  include Devise::TestHelpers
  fixtures :all
  render_views

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:cao]
    @role = FactoryGirl.create(:role, name: "COA")
    @profile = FactoryGirl.create(:profile, profile_name: "Doctor")
  end

  describe "GET 'new'" do
    it "I should be able to add new coa" do
      get :new, format: :html
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @valid_data = { user_id: "#jkl", first_name: "testfname", last_name: "testlname", username: "testusername", email: "fnamelname@test.com", password: "12345678", fk_profile_id: @profile.id, fk_role_id: @role.id }
    end
    it " I should be able to register as a coa" do
      post :create, format: :html, cao: @valid_data
      response.status.should == 302
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @cao = FactoryGirl.create(:cao)
      @role = FactoryGirl.create(:role, name: "Admin")
      @cao.update_attribute(:fk_role_id, @role.id)
      sign_in @cao
    end
    it "I should be able to edit the details" do
      get :edit, format: :html
      response.status.should == 200
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @cao = FactoryGirl.create(:cao, username: "testupdateuser", email: "testupdateuser@test.com", password: 12345678, password_confirmation: 12345678)
      @role = FactoryGirl.create(:role, name: "COA")
      @cao.update_attribute(:fk_role_id, @role.id)
      sign_in @cao
      @valid_data = { email: "testusername@example.com", password: 12345678, password_confirmation: 12345678, current_password: 12345678 }
    end
    it "I should be able to update the details" do
      put :update, format: :html, cao: { email: @cao.email, password: 12345678, password_confirmation: 12345678, current_password: 12345678 }
      response.status.should == 302
    end
  end

end
