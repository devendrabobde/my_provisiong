require 'email_spec'
require 'email_spec/cucumber'
require 'simplecov'
SimpleCov.start
SimpleCov.coverage_dir 'coverage/cucumber'

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require "selenium-webdriver"
require 'cucumber/rails'
require 'factory_girl'

Before do
  if ENV['HEADLESS']
    require 'headless'
    @headless = Headless.new
    @headless.start
    at_exit do
      @headless.destroy if @headless.present?
    end
  end
end

AfterConfiguration do |config|
  # delete providers details
  Provider.delete_all
  ProviderAppDetail.delete_all
  ProviderDeaNumber.delete_all
  ProviderErrorLog.delete_all
  AuditTrail.delete_all
  Organization.delete_all
  Cao.delete_all
end
Capybara.register_driver :selen do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = Rails.root.join("tmp").to_s
  profile['browser.helperApps.neverAsk.saveToDisk'] = "text/csv; charset=utf-8; header=present" # content-type of file that will be downloaded
  Capybara::Selenium::Driver.new(app, :browser => :firefox, profile: profile)
end
# require 'factory_girl/step_definitions'
# Dir["../../features/support/factories/*.rb"].each {|file| require_relative file }

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath
Capybara.default_selector = :css



Capybara.default_driver = Capybara.javascript_driver = :selenium

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

Capybara.register_driver :selenium do |app|
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.timeout = 20000
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => http_client)
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop do
      active = page.evaluate_script('jQuery.active')
      break if active == 0
    end
  end
end
