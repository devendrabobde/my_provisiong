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
		                    @router_reg_apps = OnestopRouter.request_batchupload_responders(nil)
		                    @app_hash_router = @router_reg_apps.collect{|x| x.values.flatten.select{|y| y if "#{x.keys.first}::#{y['ois_name']}" == @application.display_name}}.flatten.first rescue nil
			    	end
			    	it "After uploading a valid NPI, Rcopia Ois should have the expected result" do		    			
			    		response = ProvisioningOis::batch_upload_dest(@providers, @coa, @application, @app_hash_router).last
			    		response["status"].should == "ok"
			    		response["providers"].each do |res|
			    			res["status"].should == 200
			    			res["status_text"].should == "Success"
			    		end
	    			end
	    			it "After uploading a valid NPI, Router should have the expected result" do
		    			response = OnestopRouter::batch_upload(@providers, @application, @app_hash_router)
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