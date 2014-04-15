require "spec_helper"

#
# Rack middleware testing
#
describe PerformanceLogMiddleware do

  let(:app) { ->(env) { [200, env, []] } }

  let :middleware do
    PerformanceLogMiddleware.new(app)
  end

	it "should call performance log middileware while calling sample API" do
	  # status, env, response = middleware.call env_for(SERVER_CONFIGURATION['onestop_server_ip'])
	  status, env, response = middleware.call env_for('http://example.com')
	  status.should == 200
	end

	def env_for url, opts = {}
	  Rack::MockRequest.env_for(url, opts)
  end
end