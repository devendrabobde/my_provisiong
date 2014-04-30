# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OneStop::Application.initialize!
# ActiveRecord::Base.connection.raw_connection.exec("alter session set nls_numeric_characters = '.,'")

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # We're in smart spawning mode.
    if forked
      # Re-establish redis connection
      require 'redis'

      $redis.client.disconnect unless $redis.nil?
      $redis = Redis.new(:host => 'localhost', :port => 6379)
    end
  end
end
