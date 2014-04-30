require_relative '../spec_helper'

describe AuditTrailsLog do
  describe '#error' do
  	it "Should able to log the audit i.e file upload transaction entries" do
  		AuditTrailsLog.error "test.."
  	end
  end
end
