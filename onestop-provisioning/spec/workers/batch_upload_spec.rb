require 'spec_helper'
describe "BatchUpload" do
  describe "#perform" do
  	it "should perform" do
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
		audit_trail = FactoryGirl.create(:audit_trail)
		data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id)
  	end
  end
end