class PerformanceLog < ActiveRecord::Base
  
  attr_accessible :controller_name, :server_name, :server_version, :server_ip, :action_name,
   :client_id, :request_params, :request_ip, :request_content, :request_time, 
   :response_content, :client_platform, :client_version, :status, :error_code, :error_description, :response_time
   
  include Extensions::UUID

  alias_attribute :sys_performance_log_id, :id
  
end
