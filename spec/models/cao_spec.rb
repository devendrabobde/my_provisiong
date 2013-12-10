require 'spec_helper'

describe Cao do

  describe "Caos table should have following fields present in DB" do
    it { should have_db_column(:sys_cao_id).of_type(:string) }
    it { should have_db_column(:cao_id).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:string) }
    it { should have_db_column(:username).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }
    it { should have_db_column(:is_active).of_type(:boolean) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:sign_in_count).of_type(:integer) }
    it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string) }
    it { should have_db_column(:last_sign_in_ip).of_type(:string) }
    it { should have_db_column(:deleted_at).of_type(:datetime) }
    it { should have_db_column(:deleted_reason).of_type(:string) }
    it { should have_db_column(:fk_role_id).of_type(:string) }
    it { should have_db_column(:fk_organization_id).of_type(:string) }
    it { should have_db_column(:fk_profile_id).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "Cao should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :username }
    it { should allow_mass_assignment_of :first_name }
    it { should allow_mass_assignment_of :last_name }
    it { should allow_mass_assignment_of :user_id }
    it { should allow_mass_assignment_of :is_active }
    it { should allow_mass_assignment_of :email }
    it { should allow_mass_assignment_of :password }
    it { should allow_mass_assignment_of :password_confirmation }
    it { should allow_mass_assignment_of :remember_me }
    it { should allow_mass_assignment_of :deleted_at }
    it { should allow_mass_assignment_of :deleted_reason }
    it { should allow_mass_assignment_of :fk_profile_id }
    it { should allow_mass_assignment_of :fk_organization_id }
    it { should allow_mass_assignment_of :fk_role_id }
  end

  describe "A cao should not be able to register without following attributes" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "Cao should not be able to register with multiple username" do
    it { should validate_uniqueness_of(:username).scoped_to(:email).with_message('has already been taken') }
  end

  describe "Cao should allow email with validated format" do
    it { should_not allow_value("blah").for(:email) }
    it { should allow_value("a@b.com").for(:email) }
  end

  it "Cao should be able to have multiple audit trails" do
    t = Cao.reflect_on_association(:audit_trails)
    t.macro.should == :has_many
  end

  it "Cao should be able to have multiple provider error logs" do
    t = Cao.reflect_on_association(:provider_error_logs)
    t.macro.should == :has_many
  end

  it "Cao should be able to have multiple provider app details" do
    t = Cao.reflect_on_association(:provider_app_details)
    t.macro.should == :has_many
  end

  describe "Each Cao should belong to a role, profile and organization" do
    it { should belong_to(:role) }
    it { should belong_to(:profile) }
    it { should belong_to(:organization) }
  end
end
