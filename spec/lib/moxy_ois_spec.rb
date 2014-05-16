require_relative '../spec_helper'

describe "RCOPIA-OIS" do
	context "Batch Upload API" do
	  	describe "Moxy" do
		  	describe '#batch_upload_dest' do
			    describe "Moxy application success case for valid npi providers" do
			    	before(:each) do
			    		@coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name, first_name: Faker::Name.first_name , last_name: Faker::Name.last_name, password: "password", password_confirmation: "password")
					    @role = Role.create(name: "COA")
					    @organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address, address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name, contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
					    @coa.update_attributes(fk_role_id: @role.id, fk_organization_id: @organization_coa.id)
			    		@application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["MOXY"]).first
			 		  	@providers = [{
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
			                    }]
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
			    	it "After uploading a valid NPI, Moxy Ois should have the expected result" do		    			
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