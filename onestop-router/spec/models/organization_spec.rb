require 'spec_helper'

describe Organization do
  let(:organization) { create(:organization) }
  subject            { organization }

  it { should have_db_column(:organization_name).of_type(:string).with_options(:limit => 150) }
  it { should have_db_column(:address1).of_type(:string).with_options(:limit => 100) }
  it { should have_db_column(:address2).of_type(:string).with_options(:limit => 100) }
  it { should have_db_column(:city).of_type(:string).with_options(:limit => 100) }
  it { should have_db_column(:state_code).of_type(:string).with_options(:limit => 2) }
  it { should have_db_column(:postal_code).of_type(:string).with_options(:limit => 20) }
  it { should have_db_column(:country_code).of_type(:string).with_options(:limit => 20, :default => 'USA', :null => false) }
  it { should have_db_column(:contact_first_name).of_type(:string).with_options(:limit => 120, :null => false) }
  it { should have_db_column(:contact_last_name).of_type(:string).with_options(:limit => 120, :null => false) }
  it { should have_db_column(:contact_phone).of_type(:string).with_options(:limit => 20) }
  it { should have_db_column(:contact_fax).of_type(:string).with_options(:limit => 20) }
  it { should have_db_column(:contact_email).of_type(:string).with_options(:limit => 100) }
  it { should have_db_column(:organization_npi).of_type(:string).with_options(:limit => 10) }
  it_should_behave_like "DrFirst database object"

  it_behaves_like "records timestamps" do
    subject { build(:organization) }
  end

  it_behaves_like "syncs disabled date" do
    subject { create(:organization) }
  end

  it { should be_audited }

  it { should allow_mass_assignment_of(:organization_npi) }
  it { should allow_mass_assignment_of(:organization_name) }
  it { should allow_mass_assignment_of(:address1) }
  it { should allow_mass_assignment_of(:address2) }
  it { should allow_mass_assignment_of(:city) }
  it { should allow_mass_assignment_of(:state_code) }
  it { should allow_mass_assignment_of(:postal_code) }
  it { should allow_mass_assignment_of(:country_code) }
  it { should allow_mass_assignment_of(:contact_first_name) }
  it { should allow_mass_assignment_of(:contact_last_name) }
  it { should allow_mass_assignment_of(:contact_phone) }
  it { should allow_mass_assignment_of(:contact_fax) }
  it { should allow_mass_assignment_of(:contact_email) }
  it { should allow_mass_assignment_of(:disabled) }

  context "validation" do
    subject { create(:organization) }

    it { should validate_presence_of(:country_code) }
    it { should validate_uniqueness_of(:organization_npi) }

    it { should validate_format_of(:contact_first_name).with("Nicholas") }
    it { should validate_format_of(:contact_last_name).with("Hance") }
    it { should validate_format_of(:country_code).with("United States") }
    it { should validate_format_of(:organization_npi).with("0123456789") }
    it { should validate_format_of(:organization_name).with("Reenhanced LLC") }
  end

  context "instance methods" do
    its(:display_name) { should == organization.organization_name }
  end
end
