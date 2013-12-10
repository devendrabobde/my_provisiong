class ProviderAppDetail < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :status_code, :status_text, :fk_cao_id, :fk_registered_app_id, :fk_audit_trail_id,
  :fk_organization_id

  alias_attribute :sys_provider_app_detail_id, :id

  #
  # Associations
  #
  has_one :provider, foreign_key: :fk_provider_app_detail_id
  has_many :provider_dea_numbers, foreign_key: :fk_provider_app_detail_id
  belongs_to :cao, foreign_key: :fk_cao_id
  belongs_to :registered_app, foreign_key: :fk_registered_app_id
  belongs_to :audit_trail, foreign_key: :fk_audit_trail_id
  belongs_to :organization, foreign_key: :fk_organization_id

  #
  # Class methods
  #
  def self.find_provider_app_details(ids)
    where("sys_provider_app_detail_id in (?)", ids)
  end

end
