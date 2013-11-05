require 'spec_helper'

describe PasswordsController do
  describe "POST /passwords" do
    it "returns a new password" do
      password = Password.new
      Password.stub(:new => password)
      post :create
      response.body.should == password
    end
  end
end
