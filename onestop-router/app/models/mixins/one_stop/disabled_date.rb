module Mixins::OneStop::DisabledDate
  extend ActiveSupport::Concern

  included do
    before_save :update_disabled_date, :if => :disabled_changed?
  end

  private
  def update_disabled_date
    if disabled?
      self.disabled_date = Time.now
    else
      self.disabled_date = nil
    end
  end
end
