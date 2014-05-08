require_relative '../spec_helper'

describe "ProvisioingCsvValidation" do
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
  
  describe "#process_csv_api" do

  	it "should process the csv file of providers for EPCS-IDP application" do
	  path = "#{Rails.root}/public/rspec_test_files/epcs/valid_epcs_providers.csv"
	  application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
	  response = ProvisioingCsvValidation.process_csv_api(path, @router_reg_apps)  		
	  assert response.should be_true
  	end

  	it "should process the csv file of providers for Rcopia application" do
	  path = "#{Rails.root}/public/rspec_test_files/rcopia/valid_rcopia_providers.csv"
	  application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["RCOPIA"]).first
	  response = ProvisioingCsvValidation.process_csv_api(path, @router_reg_apps)  		
	  assert response.should be_true
  	end

  end

  # describe "#validate_required_field" do

  # 	it "should validate required field of providers" do
  # 	  providers = [
  #       {:npi=>"1194718007",
  #       :last_name=>"CASEY",
  #       :first_name=>"THOMAS",
  #       :address_1=>"28411 NORTHWESTERN HWY",
  #       :address_2=>"STE # 1050",
  #       :city=>"SOUTHFIELD",
  #       :state=>"MI",
  #       :zip=>"480345544",
  #       :email=>"bparker@rcopia.com",
  #       :provider_otp_token_serial=>"VSHM31349119",
  #       :resend_flag=>nil,
  #       :hospital_admin_first_name=>"Jill",
  #       :hospital_admin_last_name=>"Parks",
  #       :idp_performed_date=>"08/30/2013",
  #       :idp_performed_time=>"14:29:13",
  #       :hospital_idp_transaction_id=>"1111221",
  #       :middle_name=>"parker",
  #       :prefix=>"Dr.",
  #       :gender=>"M",
  #       :birth_date=>"12/04/1988",
  #       :social_security_number=>"890629517",
  #       :provider_dea_record=>[{:provider_dea=>"BC3818892",:provider_dea_state=>"MD",:provider_dea_expiration_date=>"03/01/1988"}]},
  #      {:npi=>"1215930243",
  #       :last_name=>"VINCENT",
  #       :first_name=>"ANDREW",
  #       :address_1=>"28411 NORTHWESTERN HWY",
  #       :address_2=>"STE # 1050",
  #       :city=>"SOUTHFIELD",
  #       :state=>"MI",
  #       :zip=>"480345544",
  #       :email=>"Andrew@gmail.com",
  #       :provider_otp_token_serial=>"IGH0945785567",
  #       :resend_flag=>nil,
  #       :hospital_admin_first_name=>"Jill",
  #       :hospital_admin_last_name=>"Parks",
  #       :idp_performed_date=>"08/30/2013",
  #       :idp_performed_time=>"14:29:13",
  #       :hospital_idp_transaction_id=>"11112211",
  #       :middle_name=>"parker",
  #       :prefix=>"Dr.",
  #       :gender=>"M",
  #       :birth_date=>"12/04/1988",
  #       :social_security_number=>"890629517",
  #       :provider_dea_record=>
  #        [{:provider_dea=>"BV8234661",
  #          :provider_dea_state=>"VA",
  #          :provider_dea_expiration_date=>"03/01/1988"}]}]
  #     application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
  #     response = ProvisioingCsvValidation.validate_required_field(providers, application)  		
	 #  assert response.should be_true
  # 	end

  # end

end