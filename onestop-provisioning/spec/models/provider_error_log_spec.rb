require 'spec_helper'

describe ProviderErrorLog do

  describe "ProviderErrorLogs table should have following fields present in DB" do
    it { should have_db_column(:sys_provider_error_log_id).of_type(:string) }
    it { should have_db_column(:provider_error_log_id).of_type(:string) }
    it { should have_db_column(:application_name).of_type(:string) }
    it { should have_db_column(:error_message).of_type(:text) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "ProviderErrorLog should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :application_name }
    it { should allow_mass_assignment_of :error_message }
    it { should allow_mass_assignment_of :fk_provider_id }
    it { should allow_mass_assignment_of :fk_cao_id }
    it { should allow_mass_assignment_of :fk_audit_trail_id }
  end

  describe "Each ProviderErrorLog should belong to a provider and cao" do
    it { should belong_to(:provider) }
    it { should belong_to(:cao) }
  end
end
