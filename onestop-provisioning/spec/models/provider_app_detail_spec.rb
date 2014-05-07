require 'spec_helper'

describe ProviderAppDetail do

  describe "ProviderAppDetails table should have following fields present in DB" do
    it { should have_db_column(:sys_provider_app_detail_id).of_type(:string) }
    it { should have_db_column(:provider_app_detail_id).of_type(:string) }
    it { should have_db_column(:status_code).of_type(:string) }
    it { should have_db_column(:status_text).of_type(:text) }
    it { should have_db_column(:fk_cao_id).of_type(:string) }
    it { should have_db_column(:fk_registered_app_id).of_type(:string) }
    it { should have_db_column(:fk_audit_trail_id).of_type(:string) }
    it { should have_db_column(:fk_organization_id).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "ProviderAppDetail should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :status_code }
    it { should allow_mass_assignment_of :status_text }
    it { should allow_mass_assignment_of :fk_cao_id }
    it { should allow_mass_assignment_of :fk_registered_app_id }
    it { should allow_mass_assignment_of :fk_audit_trail_id }
    it { should allow_mass_assignment_of :fk_organization_id }
  end

  it "ProviderAppDetail should be able to have a provider" do
    t = ProviderAppDetail.reflect_on_association(:provider)
    t.macro.should == :has_one
  end

  it "ProviderAppDetail should be able to have multiple provider dea numbers" do
    t = ProviderAppDetail.reflect_on_association(:provider_dea_numbers)
    t.macro.should == :has_many
  end

  describe "#find_provider_app_details" do
    it "should return provider application details" do
      provider_app_detail = FactoryGirl.create(:provider_app_detail, sys_provider_app_detail_id: 2)
      assert ProviderAppDetail.find_provider_app_details([2]).should be_true
    end
  end
end
