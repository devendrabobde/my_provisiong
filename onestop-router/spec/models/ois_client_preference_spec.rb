require 'spec_helper'

describe OisClientPreference do
  it { should have_db_column(:preference_name).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:client_name).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:faq_url).of_type(:string).with_options(:limit => 1000) }
  it { should have_db_column(:help_url).of_type(:string).with_options(:limit => 1000) }
  it { should have_db_column(:logo_url).of_type(:string).with_options(:limit => 1000) }
  it { should have_db_column(:slug).of_type(:string).with_options(:limit => 255, :null => false) }
  it_should_behave_like "DrFirst database object"

  it_behaves_like "records timestamps" do
    subject { build(:ois_client_preference) }
  end

  it { should be_audited }
  it { should have_associated_audits }
  it { should have_many(:ois_clients) }

  it { should validate_format_of(:preference_name).with("Valid preference name") }
  it { should validate_format_of(:faq_url).with("http://www.buildbettersoftware.com/") }
  it { should validate_format_of(:help_url).with('http://www.reenhanced.com/') }
  it { should validate_format_of(:logo_url).with('http://www.drfirst.com/logo.png') }

  it "validates_uniqueness_of :preference_name" do
    pref = create(:ois_client_preference)
    pref2 = build(:ois_client_preference)
    pref2.preference_name = pref.preference_name

    pref2.should_not be_valid
    pref2.errors[:preference_name].should include("has already been taken")
  end

  it { should allow_mass_assignment_of(:preference_name) }
  it { should allow_mass_assignment_of(:faq_url) }
  it { should allow_mass_assignment_of(:help_url) }
  it { should allow_mass_assignment_of(:logo_url) }

  context "callbacks" do
    subject                      { create(:ois_client_preference) }
    let!(:client1)               { create(:ois_client, client_name: "First", ois_client_preference: subject) }
    let!(:client2)               { create(:ois_client, client_name: "Second", ois_client_preference: subject) }
    let!(:default_ois_client_preference) { create(:default_ois_client_preference) }

    describe "before_destroy" do
      it "makes all associated clients use the default private label" do
        subject.ois_clients.reload
        subject.should have(2).ois_clients
        default_ois_client_preference.should have(0).ois_clients

        subject.destroy

        default_ois_client_preference.reload
        default_ois_client_preference.should have(2).ois_clients
      end
    end

    describe "before_save" do
      it "assigns the client_name to the first client" do
        subject.client_name.should be_blank
        subject.save!
        subject.client_name.should == "First"
      end
    end
  end

  context "class methods" do
    subject { OisClientPreference }
    let!(:default_ois_client_preference) { create(:default_ois_client_preference) }

    its(:default) { should == default_ois_client_preference }
  end

  context "instance methods" do
    describe "#to_s" do
      subject { create(:ois_client_preference, :preference_name => 'Preference Name') }

      its(:to_s) { should == "Preference Name" }
    end
  end
end
