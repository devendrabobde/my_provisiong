class ProviderErrorLog < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :application_name, :error_message, :fk_provider_id, :fk_cao_id, :fk_audit_trail_id

  alias_attribute :sys_provider_error_log_id, :id

  #
  # Associations
  #
  belongs_to :provider, foreign_key: :fk_provider_id
  belongs_to :cao, foreign_key: :fk_cao_id
  belongs_to :audit_trail, foreign_key: :fk_audit_trail_id

end
