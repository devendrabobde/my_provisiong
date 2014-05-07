require 'spec_helper'

describe ProviderDeaNumber do

  describe "ProviderDeaNumbers table should have following fields present in DB" do
    it { should have_db_column(:sys_provider_dea_number_id).of_type(:string) }
    it { should have_db_column(:provider_dea_number_id).of_type(:string) }
    it { should have_db_column(:provider_dea).of_type(:string) }
    it { should have_db_column(:provider_dea_state).of_type(:string) }
    it { should have_db_column(:provider_dea_expiration_date).of_type(:datetime) }
    it { should have_db_column(:fk_provider_app_detail_id).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "ProviderDeaNumber should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :provider_dea }
    it { should allow_mass_assignment_of :provider_dea_state }
    it { should allow_mass_assignment_of :provider_dea_expiration_date }
    it { should allow_mass_assignment_of :fk_provider_app_detail_id }
  end

  describe "Each ProviderDeaNumber should belong to a provider application detail" do
    it { should belong_to(:provider_app_detail) }
  end
end
