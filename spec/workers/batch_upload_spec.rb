require 'spec_helper'
describe "BatchUpload" do
  describe "#perform" do
    before(:each) do
    @router_reg_apps = OnestopRouter.request_batchupload_responders(nil)
  end
  	it "should perform batch upload for providers for EPCS-IDP application" do
  	  providers = [
                    {
                        "npi"=>"1194718007",
                        "last_name"=>"CASEY",
                        "first_name"=>"THOMAS",
                        "address_1"=>"28411 NORTHWESTERN HWY",
                        "address_2"=>"STE # 1050",
                        "city"=>"SOUTHFIELD",
                        "state"=>"MI",
                        "zip"=>"480345544",
                        "email"=>"THOMAS@rcopia.com",
                        "provider_otp_token_serial"=>"VSHM31349119",
                        "resend_flag"=>"",
                        "hospital_admin_first_name"=>"Jill",
                        "hospital_admin_last_name"=>"Parks",
                        "idp_performed_date"=>"08/30/2013",
                        "idp_performed_time"=>"14:29:13",
                        "hospital_idp_transaction_id"=>"1101",
                        "middle_name"=>"CHU",
                        "prefix"=>"Dr.",
                        "gender"=>"M",
                        "birth_date"=>"10/10/1988",
                        "social_security_number"=>"360629514",
                        "provider_dea_record"=>[
                            {
                                "provider_dea"=>"BC3818892",
                                "provider_dea_state"=>"AL",
                                "provider_dea_expiration_date"=>"03/01/1988"
                            }
                        ]
                    }
                  ]
                           
		cao = FactoryGirl.create(:cao)
		organization = FactoryGirl.create(:organization)
    cao.update_attributes(fk_organization_id: organization.id, epcs_ois_subscribed: true, epcs_vendor_name: "ONESTOP", epcs_vendor_password: "uidyweyf8986328992")
		application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
		audit_trail = FactoryGirl.create(:audit_trail)
    router_reg_apps = @router_reg_apps.collect{|x| x.values.flatten.select{|y| y if "#{x.keys.first}::#{y['ois_name']}" == application.display_name}}.flatten.first
		data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id, router_reg_apps)
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
        cao.update_attributes(fk_organization_id: organization.id, rcopia_ois_subscribed: true, rcopia_vendor_name: "ONESTOP", rcopia_vendor_password: "uidyweyf8986328992")
        application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["RCOPIA"]).first
        audit_trail = FactoryGirl.create(:audit_trail)
        router_reg_apps = @router_reg_apps.collect{|x| x.values.flatten.select{|y| y if "#{x.keys.first}::#{y['ois_name']}" == application.display_name}}.flatten.first
        data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id, router_reg_apps)
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
                      "office_address_country"=>"US", "office_address_zip"=>"41100"                      
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
                       "office_address_country"=>"US", "office_address_zip"=>"41100"
                    }
                ]
                           
        cao = FactoryGirl.create(:cao)
        organization = FactoryGirl.create(:organization)
        cao.update_attributes(fk_organization_id: organization.id)
        application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["MOXY"]).first
        audit_trail = FactoryGirl.create(:audit_trail)
        router_reg_apps = @router_reg_apps.collect{|x| x.values.flatten.select{|y| y if "#{x.keys.first}::#{y['ois_name']}" == application.display_name}}.flatten.first
        data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id, router_reg_apps)
        assert data.should be_true
    end


    it "should not perform batch upload for invalid providers for EPCS-IDP application" do
      invalid_providers = [
                    {
                        "npi"=>"1194718007",
                        "last_name"=>"CASEY",
                        "first_name"=>"THOMAS",
                        "address_1"=>"28411 NORTHWESTERN HWY",
                        "address_2"=>"STE # 1050",
                        "city"=>"SOUTHFIELD",
                        "state"=>"MI",
                        "zip"=>"480345544",
                        "email"=>"THOMAS@rcopia.com",
                        "provider_otp_token_serial"=>"VSHM31349119",
                        "resend_flag"=>"",
                        "hospital_admin_first_name"=>"Jill",
                        "hospital_admin_last_name"=>"Parks",
                        "idp_performed_date"=>"08/30/2013",
                        "idp_performed_time"=>"14:29:13",
                        "hospital_idp_transaction_id"=>"1101",
                        "middle_name"=>"CHU",
                        "prefix"=>"Dr.",
                        "gender"=>"M",
                        "birth_date"=>"10/10/1988",
                        "social_security_number"=>"360629514",
                        "provider_dea_record"=>[
                            {
                                "provider_dea"=>"BC3818892",
                                "provider_dea_state"=>"AL",
                                "provider_dea_expiration_date"=>"03/01/1988"
                            }
                        ]
                    }
                  ]
      cao = FactoryGirl.create(:cao)
      organization = FactoryGirl.create(:organization, state_code: "AL123")
      cao.update_attributes(fk_organization_id: organization.id, epcs_ois_subscribed: true, epcs_vendor_name: "ONESTOP", epcs_vendor_password: "uidyweyf8986328992")
      application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
      audit_trail = FactoryGirl.create(:audit_trail)
      router_reg_apps = @router_reg_apps.collect{|x| x.values.flatten.select{|y| y if "#{x.keys.first}::#{y['ois_name']}" == application.display_name}}.flatten.first
      data = BatchUpload.perform(invalid_providers, cao.id, application.id, audit_trail.id, router_reg_apps)
      assert data.should be_true
    end

    it "should suceesfully authenticate providers withput NPI for EPCS-IDP application" do
      providers = [
                    {
                      "username"=>"akariouser1", "password"=>"Welcome1234", 
                      "display_name"=>"CASEY", "prefix"=>"Dr.", "first_name"=>"THOMAS",
                      "middle_name"=>"JOHN", "last_name"=>"CASEY", "suffix"=>"N", "gender"=>"M", 
                      "user_type"=>"Provider", "npi"=>"", "degrees"=>"Phd", 
                      "resident"=>"Y", "security_question"=>"Whats your pet name?", "security_answer"=>"tommy", 
                      "email"=>"CASEY@example.com", "phone"=>"2347386", "phone_extension"=>"011", 
                      "fax"=>"2347387", "fax_extension"=>"012", "address_1"=>"Jill", "address_2"=>"Parks", 
                      "city"=>"CHU", "state"=>"NY", "country"=>"US", "zip"=>"41100", "office_address_line_1"=>"Jill",
                      "office_address_line_2"=>"Parks", "office_address_city"=>"CHU", "office_address_state"=>"NY", 
                      "office_address_country"=>"US", "office_address_zip"=>"41100"
                    }
                ]
                           
        cao = FactoryGirl.create(:cao)
        organization = FactoryGirl.create(:organization)
        cao.update_attributes(fk_organization_id: organization.id)
        application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["MOXY"]).first
        audit_trail = FactoryGirl.create(:audit_trail)
        router_reg_apps = @router_reg_apps.collect{|x| x.values.flatten.select{|y| y if "#{x.keys.first}::#{y['ois_name']}" == application.display_name}}.flatten.first
        data = BatchUpload.perform(providers, cao.id, application.id, audit_trail.id, router_reg_apps)
        assert data.should be_true
    end

  end

  describe "#on_failure" do
    it "should rails an exception if the resque job gets fail while processing in queue" do
      args = [4, "", "","15081706-c35e-40a4-9c00-6ec881998c83"]
      exception = BatchUpload.any_instance.stub(message: "Resque queue is not working")
      e = BatchUpload.new
      response = BatchUpload.on_failure(e, args)
      assert response.should be_true
    end
  end
end