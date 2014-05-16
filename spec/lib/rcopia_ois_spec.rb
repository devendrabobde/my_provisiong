require_relative '../spec_helper'

describe "RCOPIA-OIS" do
	context "Batch Upload API" do
	  	describe "Rcopia" do
		  	describe '#batch_upload_dest' do
			    describe "Rcopia application success case for valid npi providers" do
			    	before(:each) do
			    		@coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name, first_name: Faker::Name.first_name , last_name: Faker::Name.last_name, password: "password", password_confirmation: "password")
					    @role = Role.create(name: "COA")
					    @organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address, address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name, contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
					    @coa.update_attributes(fk_role_id: @role.id, fk_organization_id: @organization_coa.id)
			    		@application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["RCOPIA"]).first
			 		  	@providers = [{
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
		                        [""=>[{:provider_dea=>"BV8234661"}]],
		                      "email" => "test@example.com"
		                    }]
		                    @router_reg_apps =  [
    {
      "DrFirst" =>  [
          {
              "authentication_url" =>  "https://applicationtwo_sparkway.home => 3007/users/login",
              "enrollment_url" =>  "http://10.100.10.211/users/sign_up",
              # "ip_address_concat" =>  "10.100.10.45",
              "ip_address_concat" => CONSTANT['EPCS_OIS']['TEST_SERVER_URL'],
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
              "ip_address_concat" => CONSTANT['MOXY_OIS']['TEST_SERVER_URL'],
              "ois_name" =>  "moxy",
              "ois_password" =>  "Nr7aICD51pBigc9pac3LBjYobvavptxfF0yNON6nktOwjP8ZmQT7UxxR8wxWUQQ6H5Il"
          },
          {
              "authentication_url" =>  "http://rcapia/users/login",
              "enrollment_url" =>  "http://rcopia/users/sign_up",
              # "ip_address_concat" =>  "10.100.10.45",
              "ip_address_concat" => CONSTANT['RCOPIA_OIS']['TEST_SERVER_URL'],
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
			    	it "After uploading a valid NPI, Rcopia Ois should have the expected result" do		    			
			    		response = ProvisioningOis::batch_upload_dest(@providers, @coa, @application, @router_reg_apps).last
			    		response["status"].should == "ok"
			    		response["providers"].each do |res|
			    			res["status"].should == 200
			    			res["status_text"].should == "Success"
			    		end
	    			end
	    			it "After uploading a valid NPI, Router should have the expected result" do
		    			response = OnestopRouter::batch_upload(@providers, @application, @router_reg_apps)
			    		response["status"].should == "ok"
			    		response["providers"].each do |res|
			    			res["status"].should == 200
			    			res["status_text"].should == "Success"
			    		end
	    			end
	    		end
	    	end
	    end
	end
end