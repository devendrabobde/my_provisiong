module Mixins::OneStop::Timestamps
  extend ActiveSupport::Concern

  included do
    before_create :set_created_date
    before_save   :set_last_update_date
  end

  private
  def set_created_date
    self.createddate = Time.now.utc
  end

  def set_last_update_date
    self.lastupdatedate = Time.now.utc
  end
end
