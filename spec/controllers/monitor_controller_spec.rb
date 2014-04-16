require 'spec_helper'

describe MonitorController do
  
  describe "#monitor" do
  	it "should monitor connectivity with various applications" do
  	  get :monitor, format: :html
  	  assert response.should be_true
  	end
  end

end