require 'spec_helper'

describe Devise::SessionsController do
  include Devise::TestHelpers
  fixtures :all
  render_views

  before(:each) do
    @request.env["devise.mapping"]  = Devise.mappings[:cao]
    @role                           = FactoryGirl.create(:role, name: "COA")
    @profile                        = FactoryGirl.create(:profile, profile_name: "Doctor")
  end

  describe "GET 'new'" do

    it "I should be able to see sign in form form" do
      get :new, format: :html
      response.should be_success
    end
    
  end

  describe "POST 'create'" do

    before(:each) do
      @cao  = FactoryGirl.create(:cao, username: "jill", email: "jill@test.com", password: "password@123", password_confirmation: "password@123")
      @role = FactoryGirl.create(:role, name: "COA")
      @cao.update_attribute(:fk_role_id, @role.id)
    end

    it "I should be able to sign in as a coa" do
      post :create, format: :html, cao: { username: @cao.username, password: "password@123" }
      response.status.should == 302
    end

  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @cao  = FactoryGirl.create(:cao, username: "jack", email: "jack@test.com", password: "password@123", password_confirmation: "password@123")
      @role = FactoryGirl.create(:role, name: "COA")
      @cao.update_attribute(:fk_role_id, @role.id)
      sign_in @cao
    end

    it "I should be able to delete my account" do
      delete :destroy, format: :html
    end

  end

  describe "GET 'back_button_destroy'" do

    before(:each) do
      @cao  = FactoryGirl.create(:cao, username: "jack", email: "jack@test.com", password: "password@123", password_confirmation: "password@123")
      @role = FactoryGirl.create(:role, name: "COA")
      @cao.update_attribute(:fk_role_id, @role.id)
      sign_in @cao
    end

    it "I should be able to delete my account" do
      get :back_button_destroy, format: :html
    end

  end

end