module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |substep, parent|
  with_scope(parent) { steps "When #{substep}" }
end

When /^(.*) within (.*):$/ do |substep, parent, table_or_string|
  with_scope(parent) { steps "When #{substep}:", table_or_string }
end

When /^I go to (.*)$/ do |path_name|
  visit path_to(path_name)
end

When /^I visit ['"](.+)['"]$/ do |path|
  visit path
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )(?:click) "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  page.should have_no_content(text)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following:?$/ do |fields|
  fields.rows_hash.each do |name, value|
    step %{I fill in "#{name}" with "#{value}"}
  end
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end

Then /^the "([^"]+)" field should be (un)?masked$/ do |field, unmasked|
  field_type = field_labeled(field)[:type]

  if unmasked
    field_type.should == 'text'
  else
    field_type.should == 'password'
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When "show me the page" do
  save_and_open_page
end
