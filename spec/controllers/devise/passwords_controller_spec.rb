require 'spec_helper'

describe Devise::PasswordsController do
  include Devise::TestHelpers
  fixtures :all
  render_views

  before(:each) do
    @request.env["devise.mapping"]  = Devise.mappings[:cao]
	@coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "Password@123", password_confirmation: "Password@123", security_question: "What was your childhood nickname?", security_answer: "scott")
  	role = Role.create(name: "COA")
    profile = Profile.create(profile_name: Faker::Name.first_name)
  	organization = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
  	@coa.update_attributes(fk_role_id: role.id, fk_organization_id: organization.id, fk_profile_id: profile.id)    
  end

  describe "GET 'new'" do
    it "I should be able to see form to send reset password instruction using an email" do
      get :new, format: :html
      response.should be_success
    end    
  end

  describe "POST 'create'" do
    it "I should be able to send reset username instruction on COA's email" do
      post :create, format: :html, forgot_field: '1', cao: { email: @coa.email }
      response.status.should == 302
    end
    it "I should be able to send reset password instruction on COA's email" do
      post :create, format: :html, cao: { email: @coa.email }
      response.status.should == 302
    end
    it "I should be able to see en error validation message if the email is not registered with system" do
      post :create, format: :html, cao: { email: "josh@malinator.com" }
      response.status.should == 200
    end
  end

  describe "GET 'edit'" do
    it "I should be able to see for for edit reset password" do
      @coa.send_reset_password_instructions
      get :edit, format: :html, reset_password_token: @coa.reset_password_token
      response.status.should == 200
    end

    it "I should be able to see error validation message if the reset password token sent time is invalid" do
      @coa.send_reset_password_instructions
      @coa.update_attributes(reset_password_sent_at: (Time.now-1.day))
      get :edit, format: :html, reset_password_token: @coa.reset_password_token
      response.status.should == 302
    end
    it "I should be able to see error validation message if the reset password token is invalid" do
      get :edit, format: :html, reset_password_token: @coa.reset_password_token
      response.status.should == 302
    end    
  end

  describe "PUT 'update'" do
    it "I should be able to update the password using reset password token" do
      @coa.send_reset_password_instructions
      put :update, format: :html, cao: { reset_password_token: @coa.reset_password_token, password: "password@1234", password_confirmation: "password@1234", security_question: "What was your childhood nickname?", security_answer: "scott"}
      response.status.should == 302
    end
    it "I should be able to see error validation message while updating the password using invalid reset password token" do
      put :update, format: :html, cao: { reset_password_token: @coa.reset_password_token, password: "password@1234", password_confirmation: "password@1234", security_question: "What was your childhood nickname?", security_answer: nil }
      response.status.should == 200
    end    
  end

end