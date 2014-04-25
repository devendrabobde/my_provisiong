require 'spec_helper'

describe Devise::RegistrationsController do
  include Devise::TestHelpers
  fixtures :all
  render_views

  before(:each) do
    @request.env["devise.mapping"]  = Devise.mappings[:cao]
    @role                           = FactoryGirl.create(:role, name: "COA")
    @profile                        = FactoryGirl.create(:profile, profile_name: "Doctor")
  end

  describe "GET 'new'" do

    it "I should be able to add new coa" do
      get :new, format: :html
      response.should be_success
    end
    
  end

  describe "POST 'create'" do

    before(:each) do
      @valid_data   = { user_id: "#jkl", first_name: "john", last_name: "shepherd", username: "johnsheferd", email: "johnsheferd@test.com", password: "password@123", fk_profile_id: @profile.id, fk_role_id: @role.id }
      @invalid_data = { user_id: "#jkl", first_name: "david", last_name: "miller", username: "davidmiller", email: "davidmiller", password: "password@123", fk_profile_id: @profile.id, fk_role_id: @role.id }
    end

    it "I should be able to register as a coa" do
      post :create, format: :html, cao: @valid_data
      response.status.should == 302
    end

    it "I should be able see error message while register as a coa if provided invalid information" do
      post :create, format: :html, cao: @invalid_data
      response.status.should == 200
    end

  end

  describe "GET 'edit'" do

    before(:each) do
      @cao  = FactoryGirl.create(:cao)
      @role = FactoryGirl.create(:role, name: "Admin")
      @profile = FactoryGirl.create(:profile)
      @cao.update_attributes(fk_role_id: @role.id, fk_profile_id: @profile.id)
      @cao.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: @cao.id)
      sign_in @cao
    end

    it "I should be able to edit the details" do
      get :edit, format: :html
      response.status.should == 302
    end
    
  end

  describe "PUT 'update'" do

    before(:each) do
      @cao  = FactoryGirl.create(:cao, username: "jill", email: "jill@test.com", password: "password@123", password_confirmation: "password@123")
      @role = FactoryGirl.create(:role, name: "COA")
      @profile = FactoryGirl.create(:profile)
      @cao.update_attributes(fk_role_id: @role.id, fk_profile_id: @profile.id)
      sign_in @cao
      @valid_data = { email: "testusername@example.com", password: "password@1234", password_confirmation: "password@1234", current_password: "password@123" }  
    end

    it "I should be able to update the details" do
      put :update, format: :html, cao: { email: @cao.email, password: "password@123", password_confirmation: "password@123", current_password: "password@1234" }
      response.status.should == 200
    end

    it "I should not be able to use the same password again while updating the password." do
      put :update, format: :html, cao: { email: @cao.email, password: "password@123", password_confirmation: "password@123", current_password: "password@1235" }
      response.status.should == 200
    end

    it "I should not be able to update information if password is not provided." do
      put :update, format: :html, cao: { email: @cao.email}
      response.status.should == 302
    end
    
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @cao  = FactoryGirl.create(:cao, username: "jack", email: "jack@test.com", password: "password@123", password_confirmation: "password@123")
      @role = FactoryGirl.create(:role, name: "COA")
      @cao.update_attribute(:fk_role_id, @role.id)
      @cao.old_passwords.create(encrypted_password: "Password@1234", password_archivable_type: "Cao", password_archivable_id: @cao.id)
      sign_in @cao
    end

    it "I should be able to delete my account" do
      delete :destroy, format: :html
    end

  end

  describe "GET 'cancel'" do

    it "I should be able to logout automatically if my session is expired" do
      get :cancel, format: :html
    end

  end

end