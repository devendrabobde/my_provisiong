Rails.configuration.after_initialize do
  Resque.after_fork do
    ActiveRecord::Base.connection.reconnect!
  end
end
