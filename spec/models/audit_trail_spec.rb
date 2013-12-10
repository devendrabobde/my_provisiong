require 'spec_helper'

describe AuditTrail do

   describe "AuditTrails table should have following fields present in DB" do
    it { should have_db_column(:sys_audit_trail_id).of_type(:string) }
    it { should have_db_column(:audit_trail_id).of_type(:string) }
    it { should have_db_column(:file_name).of_type(:string) }
    it { should have_db_column(:total_providers).of_type(:string) }
    it { should have_db_column(:file_url).of_type(:string) }
    it { should have_db_column(:status).of_type(:string) }
    it { should have_db_column(:upload_status).of_type(:boolean) }
    it { should have_db_column(:total_npi_processed).of_type(:integer) }
    it { should have_db_column(:created_date).of_type(:datetime) }
    it { should have_db_column(:fk_registered_app_id).of_type(:string) }
    it { should have_db_column(:fk_cao_id).of_type(:string) }
    it { should have_db_column(:fk_organization_id).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "Audit trail should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :file_name }
    it { should allow_mass_assignment_of :total_providers }
    it { should allow_mass_assignment_of :file_url }
    it { should allow_mass_assignment_of :status }
    it { should allow_mass_assignment_of :upload_status }
    it { should allow_mass_assignment_of :total_npi_processed }
    it { should allow_mass_assignment_of :fk_cao_id }
    it { should allow_mass_assignment_of :fk_registered_app_id }
    it { should allow_mass_assignment_of :fk_organization_id }
  end

  it "Audit trail should be able to have a provider error log" do
    t = AuditTrail.reflect_on_association(:provider_error_log)
    t.macro.should == :has_one
  end

  it "Audit trail should be able to have multiple provider app details" do
    t = AuditTrail.reflect_on_association(:provider_app_details)
    t.macro.should == :has_many
  end

  describe "Each audit trails should belong to a cao, registered application and organization" do
    it { should belong_to(:cao) }
    it { should belong_to(:registered_app) }
    it { should belong_to(:organization) }
  end
end
