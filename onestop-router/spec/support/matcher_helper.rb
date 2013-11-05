module MatcherHelper
  def error_code_message_response(code, message, index=0)
    json_response = JSON(response.body)
    json_response["errors"][index]["code"].should     == code
    json_response["errors"][index]["message"].should  == message
  end

  def successful_ois_json_response_authentication(ois, index=0)
    json_response = JSON(response.body)
    json_response[index]["ois_name"].should           == ois.ois_name
    json_response[index]["idp_level"].should          == ois.idp_level
    json_response[index]["authentication_url"].should == ois.authentication_url
  end

  def successful_ois_json_response_enrollment(ois, index=0)
    json_response = JSON(response.body)
    json_response[index]["ois_name"].should           == ois.ois_name
    json_response[index]["idp_level"].should          == ois.idp_level
    json_response[index]["enrollment_url"].should     == ois.enrollment_url
  end

  def successful_organization_json_response (index, user, organization, ois)
    json_response = JSON(response.body)
    json_response[index]["first_name"].should                       == user.first_name
    json_response[index]["last_name"].should                        == user.last_name
    json_response[index]["npi"].should                              == user.npi
    json_response[index]["ois_params"]["city"].should               == organization.city
    json_response[index]["ois_params"]["country"].should            == organization.country_code
    json_response[index]["ois_params"]["email_address"].should      == organization.contact_email
    json_response[index]["ois_params"]["fax_number"].should         == organization.contact_fax
    json_response[index]["ois_params"]["phone_number"].should       == organization.contact_phone
    json_response[index]["ois_params"]["postal_code"].should        == organization.postal_code
    json_response[index]["ois_params"]["state_code"].should         == organization.state_code
    json_response[index]["ois_params"]["street_address_1"].should   == organization.address1
    json_response[index]["ois_params"]["street_address_2"].should   == organization.address2
    json_response[index]["ois_slug"].should                         == ois.slug
  end

  shared_examples_for "a successful login" do
    specify "the success header values" do
      response.response_code.should             == 200
      response.headers["ResponseStatus"].should == "success"
      response.headers["ErrorCategory"].should  == "request"
      response.headers["ErrorCode"].should          be_blank
      response.headers["ErrorMessage"].should       be_blank
    end
  end

  def common_failure_headers
    response.response_code.should             == 200
    response.headers["ResponseStatus"].should == "error"
    response.headers["ErrorCategory"].should  == "request"
    response.headers["ErrorCode"].should      == "unauthorized"
  end

  shared_examples_for "a failed ois login" do
    specify "the failure header values" do
      common_failure_headers
      response.headers["ErrorMessage"].should   == "Unauthorized OIS"
    end
  end

  shared_examples_for "a failed client login" do
    specify "the failure header values" do
      common_failure_headers
      response.headers["ErrorMessage"].should   == "Unauthorized Client account"
    end
  end

  def logged_request(ois_client_id=nil)
    last_logged_request = PerformanceLog.last
    last_logged_request.should_not be_nil

    last_logged_request.client_id.should        == ois_client_id
    last_logged_request.request_content.should  == "#{@request.instance_variable_get(:@env)["REQUEST_METHOD"].upcase} #{@request.instance_variable_get(:@env)["PATH_INFO"]}"
    last_logged_request.request_ip.should       == '127.0.0.1'
    last_logged_request.server_name.should      == ServerConfiguration::CONFIG['service_name']
    last_logged_request.server_version.should   == ServerConfiguration::CONFIG['code_version'].to_s
    last_logged_request.response_size.should    > 0
    last_logged_request.response_time.should    be_within(10).of(Time.now)
    last_logged_request.request_time.should     be_within(10).of(Time.now)
    
    request_hash = Rack::Utils.parse_nested_query(@request.instance_variable_get(:@env)["QUERY_STRING"])
    request_hash.delete("ois_id")
    request_hash = Hash[request_hash.map{ |k, v| [k.to_sym, v] }]

    last_request_params = JSON.parse(last_logged_request.request_params)    
    request_hash.each do |key, value|
      last_request_params.keys.should include(key.to_s)
      last_request_params[key.to_s].should == value
    end
  end
end