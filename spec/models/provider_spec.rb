require 'spec_helper'

describe Provider do

   describe "Providers table should have following fields present in DB" do
    it { should have_db_column(:sys_provider_id).of_type(:string) }
    it { should have_db_column(:provider_id).of_type(:string) }
    it { should have_db_column(:username).of_type(:string) }
    it { should have_db_column(:password).of_type(:string) }
    it { should have_db_column(:role).of_type(:string) }
    it { should have_db_column(:prefix).of_type(:string) }
    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:middle_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }
    it { should have_db_column(:suffix).of_type(:string) }
    it { should have_db_column(:degrees).of_type(:text) }
    it { should have_db_column(:npi).of_type(:string) }
    it { should have_db_column(:birth_date).of_type(:datetime) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:address_1).of_type(:text) }
    it { should have_db_column(:address_2).of_type(:text) }
    it { should have_db_column(:city).of_type(:string) }
    it { should have_db_column(:state).of_type(:string) }
    it { should have_db_column(:postal_code).of_type(:string) }
    it { should have_db_column(:phone).of_type(:string) }
    it { should have_db_column(:fax).of_type(:string) }
    it { should have_db_column(:department).of_type(:string) }
    it { should have_db_column(:provider_otp_token_serial).of_type(:string) }
    it { should have_db_column(:resend_flag).of_type(:string) }
    it { should have_db_column(:hospital_admin_first_name).of_type(:string) }
    it { should have_db_column(:hospital_admin_last_name).of_type(:string) }
    it { should have_db_column(:idp_performed_date).of_type(:datetime) }
    it { should have_db_column(:idp_performed_time).of_type(:timestamp) }
    it { should have_db_column(:hospital_idp_transaction_id).of_type(:string) }
    it { should have_db_column(:zip).of_type(:string) }
    it { should have_db_column(:fk_provider_app_detail_id).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "Provider should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :username }
    it { should allow_mass_assignment_of :password }
    it { should allow_mass_assignment_of :role }
    it { should allow_mass_assignment_of :prefix }
    it { should allow_mass_assignment_of :first_name }
    it { should allow_mass_assignment_of :middle_name }
    it { should allow_mass_assignment_of :last_name }
    it { should allow_mass_assignment_of :suffix }
    it { should allow_mass_assignment_of :degrees }
    it { should allow_mass_assignment_of :npi }
    it { should allow_mass_assignment_of :birth_date }
    it { should allow_mass_assignment_of :email }
    it { should allow_mass_assignment_of :address_1 }
    it { should allow_mass_assignment_of :address_2 }
    it { should allow_mass_assignment_of :city }
    it { should allow_mass_assignment_of :state }
    it { should allow_mass_assignment_of :postal_code }
    it { should allow_mass_assignment_of :phone }
    it { should allow_mass_assignment_of :fax }
    it { should allow_mass_assignment_of :department }
    it { should allow_mass_assignment_of :provider_otp_token_serial }
    it { should allow_mass_assignment_of :resend_flag }
    it { should allow_mass_assignment_of :hospital_admin_first_name }
    it { should allow_mass_assignment_of :hospital_admin_last_name }
    it { should allow_mass_assignment_of :idp_performed_date }
    it { should allow_mass_assignment_of :idp_performed_time }
    it { should allow_mass_assignment_of :hospital_idp_transaction_id }
    it { should allow_mass_assignment_of :fk_provider_app_detail_id }
    it { should allow_mass_assignment_of :zip }
  end

  describe "Each Provider should belong to a a provider application provider_app_detail" do
    it { should belong_to(:provider_app_detail) }
  end

  it "Provider should be able to have multiple provider error logs" do
    t = Provider.reflect_on_association(:provider_error_logs)
    t.macro.should == :has_many
  end

  describe "#save_provider" do
    it "should save provider in database" do
      providers = [
        {:npi=>"1194718007",
        :last_name=>"CASEY",
        :first_name=>"THOMAS",
        :address_1=>"28411 NORTHWESTERN HWY",
        :address_2=>"STE # 1050",
        :city=>"SOUTHFIELD",
        :state=>"MI",
        :zip=>"480345544",
        :email=>"bparker@rcopia.com",
        :provider_otp_token_serial=>"VSHM31349119",
        :resend_flag=>nil,
        :hospital_admin_first_name=>"Jill",
        :hospital_admin_last_name=>"Parks",
        :idp_performed_date=>"08/30/2013",
        :idp_performed_time=>"14:29:13",
        :hospital_idp_transaction_id=>"1111221",
        :middle_name=>"parker",
        :prefix=>"Dr.",
        :gender=>"M",
        :birth_date=>"12/04/1988",
        :social_security_number=>"890629517",
        :provider_dea_record=>[{:provider_dea=>"BC3818892",:provider_dea_state=>"MD",:provider_dea_expiration_date=>"03/01/1988"}]},
       {:npi=>"1215930243",
        :last_name=>"VINCENT",
        :first_name=>"ANDREW",
        :address_1=>"28411 NORTHWESTERN HWY",
        :address_2=>"STE # 1050",
        :city=>"SOUTHFIELD",
        :state=>"MI",
        :zip=>"480345544",
        :email=>"Andrew@gmail.com",
        :provider_otp_token_serial=>"IGH0945785567",
        :resend_flag=>nil,
        :hospital_admin_first_name=>"Jill",
        :hospital_admin_last_name=>"Parks",
        :idp_performed_date=>"08/30/2013",
        :idp_performed_time=>"14:29:13",
        :hospital_idp_transaction_id=>"11112211",
        :middle_name=>"parker",
        :prefix=>"Dr.",
        :gender=>"M",
        :birth_date=>"12/04/1988",
        :social_security_number=>"890629517",
        :provider_dea_record=>
         [{:provider_dea=>"BV8234661",
           :provider_dea_state=>"VA",
           :provider_dea_expiration_date=>"03/01/1988"}]}]
      cao = FactoryGirl.create(:cao)
      organization = FactoryGirl.create(:organization)
      cao.update_attributes(fk_organization_id: organization.id)
      application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
      provider = Provider.save_provider(providers, cao, application)
      assert provider.should be_true
    end
  end

end