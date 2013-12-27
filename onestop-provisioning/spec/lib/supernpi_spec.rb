require_relative '../spec_helper'

describe "SuperNPI" do
  context "class methods" do
	  describe '#validate' do
	    describe "SuperNPI application is unavailable at the time when an upload begins" do
	    	it "raises an timeout/connection error when SuperNPI view_user() method is called" do
	    		application = RegisteredApp.where(app_name: "EPCS-IDP").first
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
	    		response = NpiValidation::validate(providers, application)
	    		response.each do |res|
	    			res[:validation_error_message].should =~ /SuperNPI OIS Connection refused/
	    		end
	    	end
	    end

	    describe "SuperNPI application is unreachable (network interruption) at the time when an upload begins" do
	    	it "raises an timeout/connection error when SuperNPI view_user() method is called" do
	    		application = RegisteredApp.where(app_name: "EPCS-IDP").first
		 		  providers =[{ :npi=>"1114919727", :last_name=>"KISTNER", :first_name=>"LISA",
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
	    		response = NpiValidation::validate(providers, application)
	    		response.each do |res|
	    			res[:validation_error_message].should =~ /SuperNPI OIS Connection refused/
	    		end
	    	end
	    end
	  end
	end
end