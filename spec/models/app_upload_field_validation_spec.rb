require 'spec_helper'

describe AppUploadFieldValidation do

  describe "AppUploadFieldValidation table should have following fields present in DB" do
    it { should have_db_column(:sys_app_field_validation_id).of_type(:string) }
    it { should have_db_column(:app_field_validation_id).of_type(:string) }
    it { should have_db_column(:validation).of_type(:string) }
    it { should have_db_column(:error_message).of_type(:text) }
    it { should have_db_column(:field_format).of_type(:string) }
    it { should have_db_column(:fk_app_upload_field_id).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "AppUploadFieldValidation should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :validation }
    it { should allow_mass_assignment_of :error_message }
    it { should allow_mass_assignment_of :field_format }
    it { should allow_mass_assignment_of :fk_app_upload_field_id }
  end

  describe "Each AppUploadFieldValidation should belong to a App Upload Field" do
    it { should belong_to(:app_upload_field) }
  end

end
