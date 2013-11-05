require 'spec_helper'

describe "AdminLogsIns" do
  subject { page }
  let(:admin_user) { FactoryGirl.create(:admin_user) }

  describe "login page" do
    before { visit new_admin_user_session_path }
    it { should have_field('Login') }
    it { should have_field('Password') }
  end

  describe "logging in" do
    before { visit new_admin_user_session_path }
    describe "with valid email" do
      before { admin_user_email_login(admin_user) }
      its(:current_path) { should == admin_root_path }
    end
    describe "with valid user_name" do
      before { admin_user_name_login(admin_user) }
      its(:current_path) { should == admin_root_path }
    end
    describe "with disabled account" do
      before do
        admin_user.disabled = true
        admin_user.save
        admin_user_name_login(admin_user)
      end
      its(:current_path) { should == new_admin_user_session_path }
      it { should have_text "Your account is disabled." }
    end
  end
end
