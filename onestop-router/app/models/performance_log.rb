class PerformanceLog < ActiveRecord::Base
  self.table_name = 'onestop_performance_log'

  include Mixins::OneStop::Timestamps

  serialize :request_params

  attr_accessible :client_id, :request, :request_params, :page_duration, :view_duration, :db_duration, :status
end
