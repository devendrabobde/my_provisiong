Rails.configuration.after_initialize do
  Resque.after_fork do
    ActiveRecord::Base.connection.reconnect!
  end
end

resque_config = YAML.load_file(Rails.root + 'config/resque.yml')

$redis = Redis.connect(:host => 'localhost', :port => 6379)
Resque.redis = $redis

