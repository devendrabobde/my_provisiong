require 'spec_helper'

describe RegisteredApp do

  describe "RegisteredApps table should have following fields present in DB" do
    it { should have_db_column(:sys_registered_app_id).of_type(:string) }
    it { should have_db_column(:registered_app_id).of_type(:string) }
    it { should have_db_column(:app_name).of_type(:string) }
    it { should have_db_column(:data_template).of_type(:text) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "RegisteredApp should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :app_name }
    it { should allow_mass_assignment_of :data_template }
  end

  it "RegisteredApp should be able to have multiple audit trails" do
    t = RegisteredApp.reflect_on_association(:audit_trails)
    t.macro.should == :has_many
  end

  it "RegisteredApp should be able to have multiple provider application details" do
    t = RegisteredApp.reflect_on_association(:provider_app_details)
    t.macro.should == :has_many
  end
  it "RegisteredApp should be able to have multiple app upload fileds" do
    t = RegisteredApp.reflect_on_association(:app_upload_fields)
    t.macro.should == :has_many
  end
end
