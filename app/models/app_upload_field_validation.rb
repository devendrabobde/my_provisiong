class AppUploadFieldValidation < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :fk_app_upload_field_id, :validation, :error_message, :field_format

  self.sequence_name = 'APP_FIELD_VALIDATIONS_SEQ'

  alias_attribute :sys_app_field_validation_id, :id

  # hooks to manipulate cached
  # after_save  :add_or_update_cached
  # after_destroy :remove_from_cached, :add_or_update_cached

  #
  # Assocations
  #
  belongs_to :app_upload_field, foreign_key: :fk_app_upload_field_id

  # method will return registered_app of validation
  def register_app
  	self.app_upload_field.registered_app
  end

  # method will remove validations from cached
  # def remove_from_cached
  #   app = register_app
  #   RedisCache.delete_validation_cached(app.app_name)
  # end

  # # method will add or update validations in cached
  # def add_or_update_cached
  #   RedisCache.set_validation_cached(register_app)
  # end

end
