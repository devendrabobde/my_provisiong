require 'spec_helper'

describe AppUploadField do
  describe "AppUploadFields table should have following fields present in DB" do
    it { should have_db_column(:sys_app_upload_field_id).of_type(:string) }
    it { should have_db_column(:app_upload_field_id).of_type(:string) }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:field_type).of_type(:string) }
    it { should have_db_column(:required).of_type(:boolean) }
    it { should have_db_column(:display_name).of_type(:string) }
    it { should have_db_column(:fk_registered_app_id).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "AppUploadField should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :name }
    it { should allow_mass_assignment_of :field_type }
    it { should allow_mass_assignment_of :required }
    it { should allow_mass_assignment_of :display_name }
    it { should allow_mass_assignment_of :fk_registered_app_id }
  end

  it "AppUploadField should be able to have multiple App Upload Field Validations" do
    t = AppUploadField.reflect_on_association(:app_upload_field_validations)
    t.macro.should == :has_many
  end

  describe "Each AppUploadField should belong to a Registered Application" do
    it { should belong_to(:registered_app) }
  end

  describe "#register_app" do
    it "should return registered application of validation" do
      registered_app = FactoryGirl.create(:registered_app)
      app_upload_field = FactoryGirl.create(:app_upload_field, fk_registered_app_id: registered_app.id)
      assert app_upload_field.register_app.should be_true
    end
  end

  # describe "#remove_from_cached" do
  #   it "should remove validations from cached" do
  #     registered_app = FactoryGirl.create(:registered_app)
  #     app_upload_field = FactoryGirl.create(:app_upload_field, fk_registered_app_id: registered_app.id)
  #     assert app_upload_field.remove_from_cached.should be_true
  #   end
  # end

  # describe "#add_or_update_cached" do
  #   it "should add or update validations in cached" do
  #     registered_app = FactoryGirl.create(:registered_app)
  #     app_upload_field = FactoryGirl.create(:app_upload_field, fk_registered_app_id: registered_app.id)
  #     assert app_upload_field.add_or_update_cached.should be_true
  #   end
  # end
end
