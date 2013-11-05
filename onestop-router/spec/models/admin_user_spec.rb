require 'spec_helper'

describe AdminUser do
  it { should have_db_column(:user_name).of_type(:string).with_options(:limit => 120) }
  it { should have_db_column(:email).of_type(:string) }
  it { should have_db_column(:encrypted_password).of_type(:string) }
  it { should have_db_column(:reset_password_token).of_type(:string) }
  it { should have_db_column(:reset_password_sent_at).of_type(:timestamp) }
  it { should have_db_column(:sign_in_count).of_type(:integer) }
  it { should have_db_column(:current_sign_in_at).of_type(:timestamp) }
  it { should have_db_column(:last_sign_in_at).of_type(:timestamp) }
  it { should have_db_column(:current_sign_in_ip).of_type(:string) }
  it { should have_db_column(:last_sign_in_ip).of_type(:string) }

  it { should be_audited }

  it "validates_uniqueness_of :user_name" do
    user = create(:admin_user, :user_name => "Pete")
    user2 = build(:admin_user, :user_name => "Pete")
    user2.user_name = user.user_name

    user2.should_not be_valid
    user2.errors[:user_name].should include("has already been taken. Try suggested usernames: Pete1, Pete2")
  end

  it { should validate_presence_of(:user_name) }
  it { should validate_format_of(:user_name).not_with("No spaces") }

  it { should allow_mass_assignment_of(:user_name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:remember_me) }
  it { should allow_mass_assignment_of(:disabled) }

  it_should_behave_like "syncs disabled date" do
    subject { create(:admin_user) }
  end

  context "instance methods" do
    subject { create(:admin_user, :user_name => 'reenhanced') }

    its(:display_name) { should == 'reenhanced' }
  end
end
