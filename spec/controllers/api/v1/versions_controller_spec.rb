require 'spec_helper'

describe Api::V1::VersionsController do
  describe "GET 'check_version'" do
    it "As a User, I should be able to verify application up and runining status and DB status and it should return http success" do
      get 'check_version'
      response.should be_success
    end
  end
end
