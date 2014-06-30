require 'spec_helper'

describe ApplicationHelper do
  describe "resource_name" do
    it "should display resource name" do
      status = helper.resource_name
      assert status.should be_true
    end
    it "should display resource" do
      status = helper.resource
      assert status.should be_true
    end
    it "should do mapping with devise" do
      status = helper.devise_mapping
      assert status.should be_true
    end
  end

  describe "#drop_down_link" do
    it "should display drop down link for the provided name" do
      result = helper.drop_down_link("Logout")
      assert result.should be_true
    end
  end
end