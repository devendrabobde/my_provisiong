require_relative '../spec_helper'

describe "OneStopRouter" do
  context "class methods" do
	  describe '#batch_upload' do
	    describe "Router application is unavailable at the time when an upload begins" do
	    	it "raises an timeout/connection error when onestop-router batch_upload() method is called" do
	    		application = RegisteredApp.where(app_name: "EPCS-IDP").first
	    		providers =  [{ :npi=>"1114919727", :last_name=>"KISTNER", :first_name=>"LISA" }, 
	    		              { :npi=>"1114000148", :last_name=>"MOULICK", :first_name=>"ACHINTYA"}] 
	    		response = OnestopRouter::batch_upload(providers, application)
	    		response[:error].should =~ /Connection refused/
	    	end
	    end

	    describe "Router application is unreachable (network interruption) at the time when an upload begins" do
	    	it "raises an timeout/connection error when onestop router batch_upload() method is called" do
	    		application = RegisteredApp.where(app_name: "EPCS-IDP").first
	    		providers =  [{ :npi=>"1114919727", :last_name=>"KISTNER", :first_name=>"LISA" }, 
	    		              { :npi=>"1114000148", :last_name=>"MOULICK", :first_name=>"ACHINTYA"}] 
	    		response = OnestopRouter::batch_upload(providers, application)
	    		response[:error].should =~ /Connection refused/
	    	end
	    end
	  end
	end
end