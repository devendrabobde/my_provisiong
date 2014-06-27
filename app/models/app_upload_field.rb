class AppUploadField < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :fk_registered_app_id, :name, :field_type, :required, :display_name

  alias_attribute :sys_app_upload_field_id, :id

  #
  # Associations
  #
  has_many :app_upload_field_validations, foreign_key: :fk_app_upload_field_id, dependent: :destroy
  belongs_to :registered_app, foreign_key: :fk_registered_app_id

  # method will return registered_app of validation
  def register_app
  	self.registered_app
  end

end