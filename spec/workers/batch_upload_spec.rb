require 'spec_helper'
describe "BatchUpload" do
  describe "#perform" do
    before(:each) do
    @router_reg_apps =  [
    {
      "DrFirst" =>  [
          {
              "authentication_url" =>  "https://applicationtwo_sparkway.home => 3007/users/login",
              "enrollment_url" =>  "http://10.100.10.211/users/sign_up",
              # "ip_address_concat" =>  "10.100.10.45",
              "ip_address_concat" => CONSTANT['EPCS']['TEST_SERVER_URL'],
              "validate_csv_url" => "http://localhost:3003/api/v1/ois/validations/validate-csv.json",
              "validate_provider_url" => "http://localhost:3003/api/v1/ois/validations/validate-provider.json",
              'batch_upload_url' => "http://10.100.10.45/api/v1/ois/epcs/batch_upload_dest.json",
              "ois_name" =>  "epcsidp",
              "ois_password" =>  "sImI0WW9oxfM00wLjX0TQuOxM3QiwItCesVPkf8NkTB8HqMuPpBGVURgGlKNM9mWZ"
          },
          {
              "authentication_url" =>  "http://moxy/users/login",
              "enrollment_url" =>  "http://moxy/users/sign_up",
              "validate_csv_url" => "http://localhost:3004/api/v1/ois/validations/validate-csv.json",
              "validate_provider_url" => "http://localhost:3004/api/v1/ois/validations/validate-provider.json",
              'batch_upload_url' => 'http://10.100.10.45:81/api/v1/ois/moxy/batch_upload_dest.json',
              # "ip_address_concat" =>  "10.100.10.45",
              "ip_address_concat" => CONSTANT['MOXY']['TEST_SERVER_URL'],
              "ois_name" =>  "moxy",
              "ois_password" =>  "Nr7aICD51pBigc9pac3LBjYobvavptxfF0yNON6nktOwjP8ZmQT7UxxR8wxWUQQ6H5Il"
          },
          {
              "authentication_url" =>  "http://rcapia/users/login",
              "enrollment_url" =>  "http://rcopia/users/sign_up",
              # "ip_address_concat" =>  "10.100.10.45",
              "ip_address_concat" => CONSTANT['RCOPIA']['TEST_SERVER_URL'],
              "validate_csv_url" => "http://localhost:3002/api/v1/ois/validations/validate-csv.json",
              "validate_provider_url" => "http://localhost:3002/api/v1/ois/validations/validate-provider.json",
              'batch_upload_url' => "http://10.100.10.45:84/api/v1/ois/rcopia/batch_upload_dest.json",
              "ois_name" =>  "rcopia",
              "ois_password" =>  "vCr8eTgeYE6grgjePkNA135iG6OU0W36z8py1jSM5bzco6dWfamaMlPjl2iiXogI7xc"
          }
      ]
  },
  {
      "Org1" =>  [
          {
              "authentication_url" =>  "http://test.com/login",
              "enrollment_url" =>  "http://test.com/sign_up",
              "ip_address_concat" =>  "test.com",
              "ois_name" =>  "OIS1",
              "ois_password" =>  "FA7wjlaRVzPX3SvfiYjXd2UvMSa7tFpkRPQLdlTCJxNJwxctRO1XtryNrr"
          }
      ]
  }
]
  end
  	it "should perform batch upload for providers for EPCS-IDP application" do
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
		data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id, @router_reg_apps)
        assert data.should be_true
  	end

    it "should perform batch upload for providers for Rcopia application" do
      providers = [
                    {
                      "npi"=>"1114919727",
                      "username" => "user1",
                      "role" => "doc",
                      "prefix" => "Dr.",
                      "suffix" => "M",
                      "last_name"=>"KISTNER", 
                      "first_name"=>"LISA", 
                      "middle_name" => "HEATH",
                      "use_existing_account" => "Y",
                      "member_type" => "D",
                      "practice_group" => "id_1",
                      "medical_license_number" => "12ER5",
                      "medical_license_state" => "PA",
                      "specialty" => "Physio",
                      "secondary_license" => "Test Licence",
                      "external_id_1" => "ID1",
                      "external_id_2" => "ID2",
                      "provider_dea_record"=>
                        [{:provider_dea=>"BV8234661"}],
                      "email" => "test@example.com"
                    }
                ]
                           
        cao = FactoryGirl.create(:cao)
        organization = FactoryGirl.create(:organization)
        cao.update_attributes(fk_organization_id: organization.id)
        application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["RCOPIA"]).first
        audit_trail = FactoryGirl.create(:audit_trail)
        data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id, @router_reg_apps)
        assert data.should be_true
    end

    it "should perform batch upload for providers for Moxy application" do
      providers = [
                    {
                      "username"=>"akariouser1", "password"=>"Welcome1234", 
                      "display_name"=>"CASEY", "prefix"=>"Dr.", "first_name"=>"THOMAS",
                      "middle_name"=>"JOHN", "last_name"=>"CASEY", "suffix"=>"N", "gender"=>"M", 
                      "user_type"=>"Provider", "npi"=>"1114919727", "degrees"=>"Phd", 
                      "resident"=>"Y", "security_question"=>"Whats your pet name?", "security_answer"=>"tommy", 
                      "email"=>"CASEY@example.com", "phone"=>"2347386", "phone_extension"=>"011", 
                      "fax"=>"2347387", "fax_extension"=>"012", "address_1"=>"Jill", "address_2"=>"Parks", 
                      "city"=>"CHU", "state"=>"NY", "country"=>"US", "zip"=>"41100", "office_address_line_1"=>"Jill",
                      "office_address_line_2"=>"Parks", "office_address_city"=>"CHU", "office_address_state"=>"NY", 
                      "office_address_country"=>"US", "office_address_zip"=>"41100", "validation_error_message"=>"",
                      "sys_provider_app_detail_id"=>"6a971b93-d937-4d8f-ac99-c2a4315e4101"
                    },
                    { "username"=>"akariouser2", "password"=>"Welcome1234", "display_name"=>"Heather", 
                      "prefix"=>"Dr.", "first_name"=>"TES", "middle_name"=>"John", "last_name"=>"Miller", 
                      "suffix"=>"N", "gender"=>"M", "user_type"=>"Provider", "npi"=>"1658424357", 
                      "degrees"=>"Phd", "resident"=>"Y", "security_question"=>"Whats your pet name?", 
                      "security_answer"=>"tommy", "email"=>"Heather@example.com", "phone"=>"2347386", 
                      "phone_extension"=>"011", "fax"=>"2347387", "fax_extension"=>"012", "address_1"=>"Jill", 
                      "address_2"=>"Parks", "city"=>"CHU", "state"=>"NY", "country"=>"US", "zip"=>"41100", 
                      "office_address_line_1"=>"Jill", "office_address_line_2"=>"Parks", 
                      "office_address_city"=>"CHU", "office_address_state"=>"NY",
                       "office_address_country"=>"US", "office_address_zip"=>"41100", 
                       "validation_error_message"=>"", "sys_provider_app_detail_id"=>"6948f684-a70c-4edf-96dd-c47a27aa2d44"
                    }
                ]
                           
        cao = FactoryGirl.create(:cao)
        organization = FactoryGirl.create(:organization)
        cao.update_attributes(fk_organization_id: organization.id)
        application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["MOXY"]).first
        audit_trail = FactoryGirl.create(:audit_trail)
        data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id, @router_reg_apps)
        assert data.should be_true
    end


    it "should not perform batch upload for invalid providers for EPCS-IDP application" do
      invalid_providers = [
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
                        :hospital_admin_first_name=>"Jilljack",
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
                        :hospital_admin_first_name=>"Jilljack",
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
      organization = FactoryGirl.create(:organization, state_code: "AL123")
      cao.update_attributes(fk_organization_id: organization.id)
      application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
      audit_trail = FactoryGirl.create(:audit_trail)
      data = BatchUpload.perform(invalid_providers, cao.id, application.id, audit_trail.id, @router_reg_apps)
      assert data.should be_true
    end

  end
end