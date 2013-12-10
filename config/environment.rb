# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OneStop::Application.initialize!
# ActiveRecord::Base.connection.raw_connection.exec("alter session set nls_numeric_characters = '.,'")
