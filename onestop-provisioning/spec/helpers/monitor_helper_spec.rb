require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the MonitorHelper. For example:
#
describe MonitorHelper do
  describe "display_server_status" do
    it "should display server status" do
      status = helper.display_server_status("test")
      assert status.should be_true
    end
    it "should display server is not running" do
      status = helper.display_server_status(false)
      assert status.should be_true
    end
  end
end
# describe MonitorHelper do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
