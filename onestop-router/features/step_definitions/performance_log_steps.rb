Then /^the request should have been logged( without a client id)?$/ do |without_client_id|
  raise "No @request_path exsists... make sure you first make an API request" unless @request_path
  if without_client_id
    @request_client_id = nil
  end

  last_request_log = PerformanceLog.last
  last_request_log.should be
  last_request_log.client_id.should == @request_client_id
  last_request_log.request_time.should be_within(10).of(Time.now)
  last_request_log.request_content.should == "#{@request_method.upcase} #{@request_path}"
  last_request_log.request_ip.should == '127.0.0.1'
  last_request_log.response_time.should be_within(10).of(Time.now)
  last_request_log.response_size.should > 0
  last_request_log.server_name.should == ServerConfiguration::CONFIG['service_name']
  last_request_log.server_version.should == ServerConfiguration::CONFIG['code_version'].to_s

  last_request_params = JSON.parse(last_request_log.request_params)

  @request_params.each do |key, value|
    last_request_params.keys.should include(key.to_s)
    last_request_params[key.to_s].should == value
  end
end
