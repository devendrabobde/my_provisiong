require 'spec_helper'

describe MonitorHelper do
  describe "display_server_status" do
    it "should display server status" do
      status = helper.display_server_status("test", "Onestop Provisioining App version 1.0.7 is up and running.")
      assert status.should be_true
    end
    it "should display server is not running" do
      status = helper.display_server_status(false, "Onestop Provisioining App is down.")
      assert status.should be_true
    end
  end
end