require_relative '../spec_helper'

describe "NpiValidation" do
  describe "#check_supernpi_acceptance" do
  	it "should raise an exception while checking supernpi acceptance if the providers are not provided" do
  		providers = [
                    {
                        "npi"=>"1345898004",
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
  	  error_response = NpiValidation::check_supernpi_acceptance(providers)
  	  error_response.each do |response|
  	  	response[:status].should == "500"
  	  	response[:validation_error_message].should == "SuperNPI OIS 500 Internal Server Error"
  	  end
  	end
  end

  describe "#validate_provider_npi" do
  	it "should raise an exception of checksum while validating provider if the providers checksum is not provided correctly" do
  	  providers = [
		    {
		        npi: "1410198989",
		        last_name: "ARENAS",
		        first_name: "BERTHA",
		        address_1: "3451 RIVER OAKS DR",
		        address_2: "STE # 1050",
		        city: "TROY",
		        state: "TX",
		        zip: "39283",
		        email: "BERTHA@rcopia.com",
		        provider_otp_token_serial: "AVT823231246",
		        resend_flag: "",
		        hospital_admin_first_name: "JAMIE",
		        hospital_admin_last_name: "Parks",
		        idp_performed_date: "09/30/2014",
		        idp_performed_time: "14:29:13",
		        hospital_idp_transaction_id: "1116",
		        middle_name:" TREK",
		        prefix: "Dr.",
		        gender: "M",
		        birth_date: "10/09/1991",
		        social_security_number: "3606213",
		        provider_dea_record: [
		        {
		            provider_dea: "AK9735867",
		            provider_dea_state: "TX",
		            provider_dea_expiration_date: "03/02/2015"
		        }
		      ]
		    }
		]
  	  error_response = NpiValidation::validate_provider_npi(providers)
  	  error_response.last.each do |response|
  	  	response[:validation_error_message].should == "NPI Checksum Invalid"
  	  end
  	end
  end
end