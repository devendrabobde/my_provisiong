Given /^I have the following HTTP headers set:$/ do |http_headers|
  http_headers.rows_hash.each do | key, value |
    page.driver.header key, value
  end
end

Then /^the HTTP headers should contain:$/ do |http_headers|
  http_headers.rows_hash.each do | key, value |
    if page.driver.respond_to?(key.to_sym)
      page.driver.send(key.to_sym).to_s.should == value
    else
      page.driver.response_headers.keys.should include(key)
      page.driver.response_headers[key].should == value
    end
  end
end
