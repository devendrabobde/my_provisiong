class RegisteredApp < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :app_name, :data_template

  alias_attribute :sys_registered_app_id, :id

  #
  # Associations
  #
  has_many :audit_trails, foreign_key: :fk_registered_app_id
  has_many :provider_app_details, foreign_key: :fk_registered_app_id
  has_many :app_upload_fields, foreign_key: :fk_registered_app_id

end
