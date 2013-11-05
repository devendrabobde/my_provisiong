require 'spec_helper'

describe Ois do
  it { should have_db_column(:ois_name).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:ois_password).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:ip_address_concat).of_type(:string).with_options(:limit => 50) }
  it { should have_db_column(:outgoing_service_id).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:outgoing_service_password).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:enrollment_url).of_type(:string).with_options(:limit => 1000) }
  it { should have_db_column(:authentication_url).of_type(:string).with_options(:limit => 1000) }
  it { should have_db_column(:organization_id).of_type(:string).with_options(:limit => 36) }
  it { should have_db_column(:disabled).of_type(:boolean).with_options(:limit => 1, :default => false) }
  it { should have_db_column(:slug).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:idp_level).of_type(:integer) }
  it_should_behave_like "DrFirst database object"

  it { should allow_mass_assignment_of(:ois_name) }
  it { should allow_mass_assignment_of(:ois_password) }
  it { should allow_mass_assignment_of(:ip_address_concat) }
  it { should allow_mass_assignment_of(:outgoing_service_id) }
  it { should allow_mass_assignment_of(:outgoing_service_password) }
  it { should allow_mass_assignment_of(:enrollment_url) }
  it { should allow_mass_assignment_of(:authentication_url) }
  it { should allow_mass_assignment_of(:organization_id) }
  it { should allow_mass_assignment_of(:disabled) }
  it { should allow_mass_assignment_of(:idp_level) }

  it_behaves_like "records timestamps" do
    subject { build(:ois) }
  end

  it_should_behave_like "syncs disabled date" do
    subject { create(:ois) }
  end

  it_behaves_like "assigns default password" do
    subject                  { build(:ois) }
    let(:password_attribute) { :ois_password }
  end

  # Audits
  it { should be_audited }

  # Associations
  it { should have_many(:ois_user_tokens) }
  it { should have_and_belong_to_many(:users) }
  it { should belong_to(:organization) }

  context "validations" do
    it { should validate_presence_of(:organization) }
    it { should validate_format_of(:ois_name).with("OIS name") }
    it { should validate_format_of(:ois_password).with('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx52') }
    it { should validate_presence_of(:outgoing_service_id) }
    it { should validate_presence_of(:outgoing_service_password) }
    it { should validate_format_of(:enrollment_url).with('http://www.reenhanced.com/') }
    it { should validate_format_of(:authentication_url).with('http://www.reenhanced.com/') }
    it { should validate_format_of(:idp_level).with('5') }

    it "validates_uniqueness_of :ois_name" do
      ois = create(:ois)
      ois2 = build(:ois)
      ois2.ois_name = ois.ois_name

      ois2.should_not be_valid
      ois2.errors[:ois_name].should include("has already been taken")
    end
  end

  context "class methods" do
    let!(:ois_level_1)         { create(:ois, :idp_level => 1) }
    let!(:ois_level_2)         { create(:ois, :idp_level => 2) }
    let(:valid_slug)           { valid_ois.slug }
    let(:valid_password)       { Password.new }
    let(:nonexistent_slug)     { 'slug-that-is-invalid' }
    let(:invalid_password)     { 'invalid-password' }
    let!(:valid_ois)           { create(:ois, ois_name: 'Valid OIS', ois_password: valid_password, idp_level: 1) }
    subject                    { Ois }

    describe ".with_min_idp_level" do
      it "returns OISes with an idp_level equal or greater than the one specified" do
        oises_with_idp_level_2 = Ois.with_min_idp_level(2)

        oises_with_idp_level_2.should have(1).ois
        oises_with_idp_level_2.should include(ois_level_2)
        oises_with_idp_level_2.should_not include(ois_level_1)
      end
    end

    describe ".authenticate" do
      it "returns a OIS that matches the slug and password" do
        subject.authenticate(valid_slug, valid_password).should == valid_ois
      end

      it "raises Ois::Unauthorized if slug not provided" do
        expect {subject.authenticate(nil, valid_password)}.to raise_error(Ois::Unauthorized)
        expect {subject.authenticate('',  valid_password)}.to raise_error(Ois::Unauthorized)
      end

      it "raises Ois::Unauthorized if password not provided" do
        expect {subject.authenticate(valid_slug, nil)}.to raise_error(Ois::Unauthorized)
        expect {subject.authenticate(valid_slug, '')}.to raise_error(Ois::Unauthorized)
      end

      it "raises Ois::Unauthorized if ois is disabled" do
        valid_ois.disabled = true
        valid_ois.save!

        expect {subject.authenticate(valid_slug, valid_password)}.to raise_error(Ois::Unauthorized)
      end

      it "raises Ois::Unauthorized if no OIS exists for the slug and password provided" do
        expect {subject.authenticate(nonexistent_slug, valid_password)}.to raise_error(Ois::Unauthorized)
        expect {subject.authenticate(valid_slug, invalid_password)}.to raise_error(Ois::Unauthorized)
        expect {subject.authenticate(nonexistent_slug, invalid_password)}.to raise_error(Ois::Unauthorized)
      end
    end
  end

  context "instance methods" do
    let(:user) { create(:user) }
    let(:organization) { subject.organization }
    let(:default_ois_response) {
      {
        first_name: user.first_name,
        last_name: user.last_name,
        npi: user.npi,
        ois_params: {
          city:              organization.city,
          country:           organization.country_code,
          email_address:     organization.contact_email,
          fax_number:        organization.contact_fax,
          phone_number:      organization.contact_phone,
          postal_code:       organization.postal_code,
          state_code:        organization.state_code,
          street_address_1:  organization.address1,
          street_address_2:  organization.address2
        },
        ois_slug: subject.slug
      }
    }
    subject { create(:ois, :ois_name => 'Rambo Connection') }

    before do
      subject.users << user
      subject.save!
    end

    it "creates a unique slug based on the ois name" do
      subject.slug.should == 'rambo-connection'
    end

    describe "#view_user" do
      it "returns a JSON object with user details for the ois" do
        subject.view_user(user).should == default_ois_response
      end

      it "returns a JSON object with ois details if a user is not provided" do
        subject.view_user.should == default_ois_response.delete_if { |key, value|
                                      [:first_name, :last_name, :npi].include?(key)
                                    }
      end
    end
  end
end
