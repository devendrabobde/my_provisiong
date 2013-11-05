module JsonRequests
  [:get, :post, :put, :delete].each do |verb|
    define_method("json_#{verb}") do |path, *args|
      args = args[0]
      headers = args.delete(:headers)
      headers ||= {}
      custom_headers = {}
      headers.each do |key, value|
        custom_headers["HTTP_#{key.upcase}".to_sym] = value
        page.driver.header key.to_s, value
      end

      page.driver.header "Content-Type", 'application/json'
      page.driver.header "Accept", 'application/json'

      @request_method = verb
      @request_path   = path
      @request_params = args

      if verb =~ /post/i
        page.driver.send(verb, URI.encode(path), args.to_json, custom_headers)
      else
        page.driver.send(verb, URI.encode(path), args, custom_headers)
      end
    end
  end

  # needed for json_spec gem, see: https://github.com/collectiveidea/json_spec
  def last_json
    page.driver.html
  end
end
World(JsonRequests)

def act_as_valid_client
  @client ||= (OisClient.last || create(:ois_client))
  @request_client_id = @client.id

  @headers = {
    'ClientId' => @client.client_name,
    'ClientPassword' => @client.client_password
  }
end

def act_as_valid_ois
  @ois ||= (Ois.last || create(:ois))
  @request_client_id = nil

  @headers = {
    'OisId' => @ois.slug,
    'OisPassword' => @ois.ois_password
  }
end

When /^I make an API GET request to ['"](.*)['"] as a valid client$/ do |path|
  act_as_valid_client
  json_get path, :headers => @headers
end

When /^I make an API GET request to ['"](.*)['"] as a valid client with:$/ do |path, table|
  act_as_valid_client
  json_get path, {:headers => @headers}.merge!(table.rows_hash.symbolize_keys)
end

When /I make an API POST request to ['"](.*)['"] as a valid [oO][iI][sS]$/ do |path|
  act_as_valid_ois
  json_post path, {:headers => @headers}
end

When /I make an API POST request to ['"](.*)['"] as a valid [oO][iI][sS] with:$/ do |path, table|
  act_as_valid_ois
  json_post path, {:headers => @headers}.merge!(table.rows_hash.symbolize_keys)
end

When /^I make an API GET request to ['"](.*)['"]$/ do |path|
  @request_client_id = nil
  json_get path, {}
end

When /^I make an API GET request to ['"](.*)['"] with the following headers:$/ do |path, table|
  @request_client_id = nil
  json_get path, :headers => table.rows_hash
end

When /^I make an API POST request to ['"](.*)['"] with:$/ do |path, table|
  @request_client_id = nil
  post_request     = table.rows_hash.symbolize_keys
  squashed_headers = post_request.delete(:headers)
  headers          = {}

  if squashed_headers.present?
    squashed_headers = squashed_headers.split(", ")

    squashed_headers.each do |header|
      header_key, header_value = header.split(': ')
      headers[header_key] = header_value
    end
  end

  json_post path, post_request.merge(:headers => headers)
end

Then /^I should get a response with "(.*)" status $/ do |status|
    page.status_code.should include(Rack::Utils.status_code(status.to_sym))
end
