require_relative '../spec_helper'

describe "ProvisioingCsvValidation" do
  before(:each) do
    @router_reg_apps = OnestopRouter.request_batchupload_responders(nil)
  end
  
  describe "#process_csv_api" do

  	it "should process the csv file of providers for EPCS-IDP application" do
  	  path = "#{Rails.root}/public/rspec_test_files/epcs/valid_epcs_providers.csv"
  	  application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
  	  response = ProvisioingCsvValidation.process_csv_api(path, application, @router_reg_apps)  		
  	  assert response.should be_true
  	end

  	it "should process the csv file of providers for Rcopia application" do
  	  path = "#{Rails.root}/public/rspec_test_files/rcopia/valid_rcopia_providers.csv"
  	  application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["RCOPIA"]).first
  	  response = ProvisioingCsvValidation.process_csv_api(path, application, @router_reg_apps)  		
  	  assert response.should be_true
  	end

    it "should process the csv file of providers for Moxy application" do
      path = "#{Rails.root}/public/rspec_test_files/rcopia/valid_rcopia_providers.csv"
      application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["MOXY"]).first
      response = ProvisioingCsvValidation.process_csv_api(path, application, @router_reg_apps)      
      assert response.should be_true
    end

  end


  describe "#validate_provider_api" do

    before(:each) do
      @providers = [
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
    end
    it "should process the csv file of providers for EPCS-IDP application" do
      path = "#{Rails.root}/public/rspec_test_files/epcs/valid_epcs_providers.csv"
      application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["EPCS"]).first
      response = ProvisioingCsvValidation.validate_provider_api(@providers, application, @router_reg_apps)      
      assert response.should be_true
    end

    it "should process the csv file of providers for Rcopia application" do
      path = "#{Rails.root}/public/rspec_test_files/rcopia/valid_rcopia_providers.csv"
      application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["RCOPIA"]).first
      response = ProvisioingCsvValidation.validate_provider_api(@providers, application, @router_reg_apps)            
      assert response.should be_true
    end

    it "should process the csv file of providers for Moxy application" do
      path = "#{Rails.root}/public/rspec_test_files/rcopia/valid_moxy_providers.csv"
      application = RegisteredApp.where(app_name: CONSTANT["APP_NAME"]["MOXY"]).first
      response = ProvisioingCsvValidation.validate_provider_api(@providers, application, @router_reg_apps)      
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