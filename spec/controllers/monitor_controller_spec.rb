require 'spec_helper'

describe MonitorController do
  
  describe "#monitor" do
  	it "should monitor connectivity with various applications" do
  	  get :monitor, format: :html
  	  assert response.should be_true
  	end
  end

  describe "#verify_connectivity" do
  	it "should raise en exception if url is not provided" do
  	  res = controller.instance_eval{ verify_connectivity(nil) }
  	  res["result"].should be_false
  	end
  end

end