require 'spec_helper'

describe Organization do

  describe "Organizations table should have following fields present in DB" do
    it { should have_db_column(:sys_organization_id).of_type(:string) }
    it { should have_db_column(:organization_id).of_type(:string) }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:address1).of_type(:string) }
    it { should have_db_column(:address2).of_type(:string) }
    it { should have_db_column(:city).of_type(:string) }
    it { should have_db_column(:state_code).of_type(:string) }
    it { should have_db_column(:postal_code).of_type(:string) }
    it { should have_db_column(:country_code).of_type(:string) }
    it { should have_db_column(:contact_fax).of_type(:string) }
    it { should have_db_column(:contact_email).of_type(:string) }
    it { should have_db_column(:deleted_at).of_type(:datetime) }
    it { should have_db_column(:deleted_reason).of_type(:string) }
    it { should have_db_column(:idp_vendor_id).of_type(:string) }
    it { should have_db_column(:vendor_label).of_type(:string) }
    it { should have_db_column(:vendor_node_label).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "Organization should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :address1 }
    it { should allow_mass_assignment_of :address2 }
    it { should allow_mass_assignment_of :city }
    it { should allow_mass_assignment_of :state_code }
    it { should allow_mass_assignment_of :postal_code }
    it { should allow_mass_assignment_of :country_code }
    it { should allow_mass_assignment_of :contact_first_name }
    it { should allow_mass_assignment_of :contact_last_name }
    it { should allow_mass_assignment_of :contact_phone }
    it { should allow_mass_assignment_of :contact_fax }
    it { should allow_mass_assignment_of :contact_email }
    it { should allow_mass_assignment_of :deleted_at }
    it { should allow_mass_assignment_of :deleted_reason }
    it { should allow_mass_assignment_of :idp_vendor_id }
    it { should allow_mass_assignment_of :vendor_label }
    it { should allow_mass_assignment_of :vendor_node_label }
  end

  describe "An Organization should not be able to register without following attributes" do
    it { should validate_presence_of(:name) }
  end

  describe "An Organization should not be able to register with multiple name" do
   it { should validate_uniqueness_of(:name) }
  end

  describe "An Organization should allow data with validated format" do
    it { should_not allow_value("blah").for(:contact_email) }
    it { should allow_value("a@b.com").for(:contact_email) }
    it { should_not allow_value("122abc").for(:contact_first_name) }
    it { should allow_value("blah").for(:contact_first_name) }
    it { should_not allow_value("abc123").for(:contact_last_name) }
    it { should allow_value("blah").for(:contact_last_name) }
  end

  it "Organization should be able to have multiple caos" do
    t = Organization.reflect_on_association(:caos)
    t.macro.should == :has_many
  end

  it "Organization should be able to have multiple provider audit trails" do
    t = Organization.reflect_on_association(:audit_trails)
    t.macro.should == :has_many
  end

  it "Organization should be able to have multiple provider app details" do
    t = Organization.reflect_on_association(:provider_app_details)
    t.macro.should == :has_many
  end
end
