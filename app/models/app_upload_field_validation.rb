class AppUploadFieldValidation < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :fk_app_upload_field_id, :validation, :error_message, :field_format

  self.sequence_name = 'APP_FIELD_VALIDATIONS_SEQ'

  alias_attribute :sys_app_field_validation_id, :id

  #
  # Assocations
  #
  belongs_to :app_upload_field, foreign_key: :fk_app_upload_field_id

  # method will return registered_app of validation
  def register_app
  	self.app_upload_field.registered_app
  end

end