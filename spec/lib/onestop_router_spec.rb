require_relative '../spec_helper'

describe "OneStopRouter" do
  before(:each) do
  @router_reg_apps = [
    {
        "DrFirst" =>  [
            {
                "authentication_url" =>  "https://applicationtwo_sparkway.home => 3007/users/login",
                "enrollment_url" =>  "http://10.100.10.211/users/sign_up",
                "ip_address_concat" =>  "10.100.10.45",
                "ois_name" =>  "epcsidp",
                "ois_password" =>  "sImI0WW9oxfM00wLjX0TQuOxM3QiwItCesVPkf8NkTB8HqMuPpBGVURgGlKNM9mWZ"
            },
            {
                "authentication_url" =>  "http://moxy/users/login",
                "enrollment_url" =>  "http://moxy/users/sign_up",
                "ip_address_concat" =>  "10.100.10.45",
                "ois_name" =>  "moxy",
                "ois_password" =>  "Nr7aICD51pBigc9pac3LBjYobvavptxfF0yNON6nktOwjP8ZmQT7UxxR8wxWUQQ6H5Il"
            },
            {
                "authentication_url" =>  "http://rcapia/users/login",
                "enrollment_url" =>  "http://rcopia/users/sign_up",
                "ip_address_concat" =>  "10.100.10.45",
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

  context "class methods" do
	  describe '#batch_upload' do
	    describe "Router application is unavailable at the time when an upload begins" do
	    	it "raises an timeout/connection error when onestop-router batch_upload() method is called" do
	    		application = RegisteredApp.where(app_name: "EPCS-IDP").first
	    		providers =  [{ :npi=>"1114919727", :last_name=>"KISTNER", :first_name=>"LISA" }, 
	    		              { :npi=>"1114000148", :last_name=>"MOULICK", :first_name=>"ACHINTYA"}] 
	    		response = OnestopRouter::batch_upload(providers, application, @router_reg_apps)
	    		response[:error].should =~ /Connection refused/
	    	end
	    end

	    describe "Router application is unreachable (network interruption) at the time when an upload begins" do
	    	it "raises an timeout/connection error when onestop router batch_upload() method is called" do
	    		application = RegisteredApp.where(app_name: "EPCS-IDP").first
	    		providers =  [{ :npi=>"1114919727", :last_name=>"KISTNER", :first_name=>"LISA" }, 
	    		              { :npi=>"1114000148", :last_name=>"MOULICK", :first_name=>"ACHINTYA"}] 
	    		response = OnestopRouter::batch_upload(providers, application, @router_reg_apps)
	    		response[:error].should =~ /Connection refused/
	    	end
	    end
	    describe "#batch_upload" do
	    	it "should do batch upload of providers for Rcopia application" do
	    		providers =  [
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
                                  "secondary_licence" => "Test Licence",
                                  "external_id_1" => "ID1",
                                  "external_id_2" => "ID2",
                                  "provider_dea_record"=>
                                    [{:provider_dea=>"BV8234661"}],
                                  "email" => "test@example.com"
                                  }
                              ]
                application = RegisteredApp.where(app_name: "Rcopia").first
	    		response = OnestopRouter::batch_upload(providers, application, @router_reg_apps)
	    		assert response.should be_true
	    	end
	    end
	    describe "#batch_upload" do
	    	it "should do batch upload of providers for Moxy application" do
	    		providers =  [
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
						        }
                              ]
                application = RegisteredApp.where(app_name: "Moxy").first
	    		response = OnestopRouter::batch_upload(providers, application, @router_reg_apps)
	    		assert response.should be_true
	    	end
	    end
	  end
	end
end