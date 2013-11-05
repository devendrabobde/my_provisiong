require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  describe "visit a non-existent page" do
    specify "the routing error" do
      expect { get 'big_daddy' }.to raise_error(ActionController::RoutingError)
    end
    specify "the correct HTTP headers" do
      get 'index'
      response.response_code.should             == 200
      response.headers["ResponseStatus"].should == "error"
      response.headers["ErrorCategory"].should  == "request"
      response.headers["ErrorCode"].should      == "not-found"
      response.headers["ErrorMessage"].should   == "Record not found"
    end
  end
end