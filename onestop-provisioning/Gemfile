source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Oracle interface ruby gem
gem 'ruby-oci8', '2.1.5'
gem 'activerecord-oracle_enhanced-adapter', '1.4.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem "twitter-bootstrap-rails"
gem "therubyracer", :platform => :ruby
gem 'devise', "=2.1.0"
gem 'rest-client'
gem 'smarter_csv'
gem 'resque', :require => 'resque/server'
gem "spreadsheet", "0.7.7"

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
#gem 'capistrano'
gem 'capistrano'#, '2.14.2'
gem 'capistrano-ext'
gem 'rvm-capistrano'
gem 'strong_parameters'
gem 'pry'
gem 'uuidtools'
gem 'savon'

# Rspec
group :development, :test do
  gem "rspec-rails", ">= 2.12.2"
  gem 'cucumber-rails', :require => false
  gem "shoulda"
  gem "factory_girl_rails", ">= 4.2.0"
  gem 'faker'
  gem 'brakeman', :require => false
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "email_spec", ">= 1.4.0"
  gem "capybara", ">= 2.0.3"
  gem "shoulda-matchers"
  gem 'simplecov', require: false
  gem 'selenium-webdriver'
  gem 'selenium'
  gem 'headless'
  gem 'rspec-core'
end

# gem "bullet", :group => "development"
# gem 'quiet_assets', :group => :development
# gem 'awesome_print', group: :development
# gem 'thin'
# gem 'ruby-growl', group: :development
# gem 'ruby_gntp', group: :development
# gem 'xmpp4r', group: :development
# gem 'airbrake', group: :development


# settingslogic - To maintain all settings
gem 'settingslogic'

# redis cache used
gem 'redis-rails'
gem 'redis-rack-cache'
#gem 'newrelic_rpm'
gem 'encryptor'
gem 'useragent'
