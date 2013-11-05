Then /I should be logged in as "([^"]+)"$/ do |username|
  step %{I should see "#{username}" within the admin menu bar}
end

Given /^I am logged in with "([^"]+)\/([^"]+)"$/ do |email, password|
  steps %{
    When I go to the admin page
    And I fill in "Login" with "#{email}"
    And I fill in "Password" with "#{password}"
    And I press "Login"
  }
end

Given /^the administrator "([^"]+)" is disabled$/ do |email|
  admin_user = AdminUser.find_by_email email
  admin_user.disabled = true
  admin_user.save!
end

Given /^the next password generated will be "([^"]+)"$/ do |password|
  Password.stub(:new => password)
end

Then /the admin user "([^"]+)" should be disabled$/ do |user_name|
  admin_user = AdminUser.find_by_user_name(user_name)
  admin_user.disabled.should be_true
end

Then "I should not be logged in" do
  page.should_not have_css(selector_for("the admin menu bar"))
end

Then /the index should contain only the following columns:/ do |table|
  headers = page.all('table.index_table thead th')
  expected_headers = table.raw
  headers.each do |header|
    unless header.text.blank?
      expected_header = expected_headers.shift.first

      header.text.should == expected_header
    end
  end

  expected_headers.count.should == 0
end
