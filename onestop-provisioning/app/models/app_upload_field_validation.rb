class AppUploadFieldValidation < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :fk_app_upload_field_id, :validation, :error_message, :field_format

  self.sequence_name = 'APP_FIELD_VALIDATIONS_SEQ'

  alias_attribute :sys_app_field_validation_id, :id

  # hooks to manipulate memcached
  after_save  :add_or_update_memcached
  after_destroy :remove_from_memcached, :add_or_update_memcached
 
  #
  # Assocations
  #
  belongs_to :app_upload_field, foreign_key: :fk_app_upload_field_id

  # method will return registered_app of validation
  def register_app
  	self.app_upload_field.registered_app
  end

  # method will remove validations from memcached
  def remove_from_memcached
  	app = register_app
  	Memcached.delete_validation_memcached(app.app_name)
  end

  # method will add or update validations in memcached
  def add_or_update_memcached
  	Memcached.set_validation_memcached(register_app)
  end

end
