require 'spec_helper'

describe Api::V1::VersionsController do
  describe "GET 'check_version'" do
    it "returns http success" do
      get 'check_version'
      response.should be_success
    end
  end
end
