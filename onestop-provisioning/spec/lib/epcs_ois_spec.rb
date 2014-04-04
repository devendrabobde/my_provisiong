require_relative '../spec_helper'

describe "EPCS-OIS" do
  context "class methods" do
	  describe '#batch_upload_dest' do
	    describe "EPCS application is unavailable at the time when an upload begins" do
	    	it "raises an timeout/connection error when EPCS batch_upload_dest() method is called" do
	    	  application = RegisteredApp.where(app_name: "EPCS-IDP").first
	    	  coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
				    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
				    password: "password", password_confirmation: "password")
			    role = Role.create(name: "COA")
			    organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
				    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
				    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345")
			    coa.update_attributes(fk_role_id: role.id, fk_organization_id: organization_coa.id)
		 	    providers = [{:npi=>"1114919727", :last_name=>"KISTNER", :first_name=>"LISA",
				                :address_1=>"28411 NORTHWESTERN HWY", :city=>"SOUTHFIELD",
				                :state=>"MI", :zip=>"93003", :phone=>"2483544709", 
				                :email=>"LISA@rcopia.com", :provider_otp_token_serial=>"AVT823231232",
				                :hospital_admin_first_name=>"Jill", :hospital_admin_last_name=>"Parks", 
				                :idp_performed_date=>"08/30/2013", :idp_performed_time=>"14:29:13", 
				                :hospital_idp_transaction_id=>"1", 
				                :provider_dea_record=>[{"provider_dea"=>"BK1948403", "provider_dea_state"=>"MD", "provider_dea_expiration_date"=>"03/01/1988"}],
				                :validation_error_message=>""
		                  }, 
				              { :npi=>"1114000148", :last_name=>"MOULICK", :first_name=>"ACHINTYA", 
				              	:address_1=>"28411 NORTHWESTERN HWY", :city=>"SOUTHFIELD", 
				              	:state=>"MI", :zip=>"93003", :phone=>"2483544709", 
				              	:email=>"MOULICK@rcopia.com", :provider_otp_token_serial=>"AVT823231232",
				              	:hospital_admin_first_name=>"Jill", :hospital_admin_last_name=>"Parks",
				              	:idp_performed_date=>"08/30/2013", :idp_performed_time=>"14:29:13", 
				              	:hospital_idp_transaction_id=>"1", 
				              	:provider_dea_record=>[{"provider_dea"=>"BM9301045", "provider_dea_state"=>"MD", "provider_dea_expiration_date"=>"03/01/1988"}], 
				              	:validation_error_message=>""
				              }]
	    	  response = ProvisioningOis::batch_upload_dest(providers, coa, application).first
	    	  response.each do |res|
	    		res[:error].should =~ /EPCS-IDP Connection refused/
	    	  end
	    	end
	    end

	    describe "EPCS application is unreachable (network interruption) at the time when an upload begins" do
	    	it "raises an timeout/connection error when EPCS view_user() method is called" do
	        coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
				          first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
				          password: "password", password_confirmation: "password")
			    role = Role.create(name: "COA")
			    organization_coa = Organization.create(name: Faker::Company.name, address1: Faker::Address.street_address,
				                    address2: Faker::Address.street_address, contact_first_name: Faker::Name.first_name,
				                    contact_last_name: Faker::Name.last_name, contact_email: Faker::Internet.email, zip_code: "12345", postal_code: "54321")
			    coa.update_attributes(fk_role_id: role.id, fk_organization_id: organization_coa.id)
	    	  application = RegisteredApp.where(app_name: "EPCS-IDP").first
		 	    providers = [{ :npi=>"1114919727", :last_name=>"KISTNER", :first_name=>"LISA",
				                :address_1=>"28411 NORTHWESTERN HWY", :city=>"SOUTHFIELD",
				                :state=>"MI", :zip=>"93003", :phone=>"2483544709", 
				                :email=>"LISA@rcopia.com", :provider_otp_token_serial=>"AVT823231232",
				                :hospital_admin_first_name=>"Jill", :hospital_admin_last_name=>"Parks", 
				                :idp_performed_date=>"08/30/2013", :idp_performed_time=>"14:29:13", 
				                :hospital_idp_transaction_id=>"1", 
				                :provider_dea_record=>[{"provider_dea"=>"BK1948403", "provider_dea_state"=>"MD", "provider_dea_expiration_date"=>"03/01/1988"}],
				                :validation_error_message=>""
				              }, 
				              { :npi=>"1114000148", :last_name=>"MOULICK", :first_name=>"ACHINTYA", 
				              	:address_1=>"28411 NORTHWESTERN HWY", :city=>"SOUTHFIELD", 
				              	:state=>"MI", :zip=>"93003", :phone=>"2483544709", 
				              	:email=>"MOULICK@rcopia.com", :provider_otp_token_serial=>"AVT823231232",
				              	:hospital_admin_first_name=>"Jill", :hospital_admin_last_name=>"Parks",
				              	:idp_performed_date=>"08/30/2013", :idp_performed_time=>"14:29:13", 
				              	:hospital_idp_transaction_id=>"1", 
				              	:provider_dea_record=>[{"provider_dea"=>"BM9301045", "provider_dea_state"=>"MD", "provider_dea_expiration_date"=>"03/01/1988"}], 
				              	:validation_error_message=>""
				              }]
	    		response = ProvisioningOis::batch_upload_dest(providers, coa, application).first
	    		response.each do |res|
	    			res[:error].should =~ /EPCS-IDP Connection refused/
	    		end
	    	end
	    end
	  end
	end
end