require 'spec_helper'

describe OisClient do
  it { should have_db_column(:client_name).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:ip_address_concat).of_type(:string).with_options(:limit => 50) }
  it { should have_db_column(:ois_client_preference_id).of_type(:string).with_options(:limit  => 36) }
  it { should have_db_column(:slug).of_type(:string).with_options(:limit => 255, :null => false) }
  it_should_behave_like "DrFirst database object"

  it_behaves_like "records timestamps" do
    subject { build(:ois_client) }
  end

  it_behaves_like "syncs disabled date" do
    subject { create(:ois_client) }
  end

  it_behaves_like "creates unique slug on create" do
    let(:factory)           { :ois_client }
    let(:slugged_attribute) { :client_name }
  end

  it_behaves_like "assigns default password" do
    subject                  { build(:ois_client) }
    let(:password_attribute) { :client_password }
  end

  it { should be_audited.associated_with(:ois_client_preference) }

  it { should allow_mass_assignment_of(:client_name) }
  it { should allow_mass_assignment_of(:client_password) }
  it { should allow_mass_assignment_of(:ip_address_concat) }
  it { should allow_mass_assignment_of(:ois_client_preference_id) }
  it { should allow_mass_assignment_of(:disabled) }

  # VALIDATIONS
  context "validation" do
    it { should validate_presence_of(:client_name) }
    it { should validate_presence_of(:slug) }
    it { should validate_format_of(:client_name).with("Test Client Name") }
    it { should validate_format_of(:client_password).with(Password.new) }
  end

  context "callbacks" do
    subject                              { build(:ois_client, client_name: 'Rambo M.D.') }
    let!(:default_ois_client_preference) { create(:default_ois_client_preference) }

    describe "before_save" do
      it "assigns the default private label if none is specified" do
        subject.ois_client_preference = nil
        subject.save!

        subject.ois_client_preference.should == default_ois_client_preference
      end

      it "does not assigns the default private label if one is specified" do
        subject.ois_client_preference = create(:ois_client_preference)
        subject.save!
        subject.ois_client_preference.should_not == default_ois_client_preference
      end
    end
  end

  context "class methods" do
    subject                { OisClient }
    let(:valid_name)       { 'client_name' }
    let(:valid_password)   { Password.new }
    let(:invalid_name)     { 'invalid_name' }
    let(:invalid_password) { 'invalid-password' }
    let!(:valid_client)    { create(:ois_client, client_name: valid_name) }

    before do
      valid_client.client_password = valid_password
      valid_client.save!
    end

    describe ".authenticate" do
      it "returns a client that matches the name and password" do
        subject.authenticate(valid_name, valid_password).should == valid_client
      end

      it "raises OisClient::Unauthorized if name not provided" do
        expect {subject.authenticate(nil, valid_password)}.to raise_error(OisClient::Unauthorized)
        expect {subject.authenticate('',  valid_password)}.to raise_error(OisClient::Unauthorized)
      end

      it "raises OisClient::Unauthorized if password not provided" do
        expect {subject.authenticate(valid_name, nil)}.to raise_error(OisClient::Unauthorized)
        expect {subject.authenticate(valid_name, '')}.to raise_error(OisClient::Unauthorized)
      end

      it "raises OisClient::Unauthorized if client is disabled" do
        valid_client.disabled = true
        valid_client.save!

        expect {subject.authenticate(valid_name, valid_password)}.to raise_error(OisClient::Unauthorized)
      end

      it "raises OisClient::Unauthorized if no client exists for the name and password provided" do
        expect {subject.authenticate(invalid_name, valid_password)}.to raise_error(OisClient::Unauthorized)
        expect {subject.authenticate(valid_name, invalid_password)}.to raise_error(OisClient::Unauthorized)
        expect {subject.authenticate(invalid_name, invalid_password)}.to raise_error(OisClient::Unauthorized)
      end
    end
  end
end
