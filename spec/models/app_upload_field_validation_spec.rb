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

  describe "#register_app" do
    it "should return registered application of validation" do
      registered_app = FactoryGirl.create(:registered_app)
      app_upload_field = FactoryGirl.create(:app_upload_field, fk_registered_app_id: registered_app.id)
      app_upload_field_validation = FactoryGirl.create(:app_upload_field_validation, fk_app_upload_field_id: app_upload_field.id)
      assert app_upload_field_validation.register_app.should be_true
    end
  end

  # describe "#remove_from_cached" do
  #   it "should remove validations from cached" do
  #     registered_app = FactoryGirl.create(:registered_app)
  #     app_upload_field = FactoryGirl.create(:app_upload_field, fk_registered_app_id: registered_app.id)
  #     app_upload_field_validation = FactoryGirl.create(:app_upload_field_validation, fk_app_upload_field_id: app_upload_field.id)
  #     app_upload_field_validation.remove_from_cached.should be_true
  #   end
  # end

  # describe "#add_or_update_cached" do
  #   it "should add or update validations in cached" do
  #     registered_app = FactoryGirl.create(:registered_app)
  #     app_upload_field = FactoryGirl.create(:app_upload_field, fk_registered_app_id: registered_app.id)
  #     app_upload_field_validation = FactoryGirl.create(:app_upload_field_validation, fk_app_upload_field_id: app_upload_field.id)
  #     app_upload_field_validation.add_or_update_cached.should be_true
  #   end
  # end

end
