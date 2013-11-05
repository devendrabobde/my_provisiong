ActiveSupport::Notifications.subscribe "api.v1.client.request"  do |name, start, finish, id, payload|
  PerformanceLog.create! do |log|
    log.client_id      = payload[:client_id]
    log.request        = payload[:path]
    log.request_params = payload[:params]
    log.status         = payload[:status]
  end
end
