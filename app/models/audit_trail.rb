class AuditTrail < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :file_name, :total_providers, :file_url,
                  :status, :fk_cao_id, :fk_registered_app_id, :fk_organization_id, :upload_status, :total_npi_processed

  alias_attribute :sys_audit_trail_id, :id

  #
  # Associations
  #
  belongs_to :cao, foreign_key: :fk_cao_id
  belongs_to :registered_app, foreign_key: :fk_registered_app_id
  belongs_to :organization, foreign_key: :fk_organization_id
  has_one :provider_error_log, foreign_key: :fk_audit_trail_id
  has_many :provider_app_details, foreign_key: :fk_audit_trail_id

end
