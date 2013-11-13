When /^I go to application home page$/ do
  visit new_cao_session_path
end

Then /^I should be able to see forgot password link$/ do
  page.should have_content("Forgot your password?")
end

And /^I should be able to click on forgot password link$/ do
  click_link "Forgot your password?"
end

When /^I enter email$/ do
  @coa = Cao.create(email: Faker::Internet.email, username: Faker::Internet.user_name,
    first_name: Faker::Name.first_name , last_name: Faker::Name.last_name,
    password: "password", password_confirmation: "password")
  fill_in "cao_email", with: @coa.email
end

And /^I press Send me reset password instructions button$/ do
  click_button "Send me reset password instructions"
end

Then /^I sould be able to see You will receive an email with instructions about how to reset your password in a few minutes.$/ do
  page.should have_content("You will receive an email with instructions about how to reset your password in a few minutes.")
end