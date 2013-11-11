class AppUploadField < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :fk_registered_app_id, :name, :field_type, :required, :display_name

  alias_attribute :sys_app_upload_field_id, :id

  #
  # Associations
  #
  has_many :app_upload_field_validations, foreign_key: :fk_app_upload_field_id, dependent: :destroy
  belongs_to :registered_app, foreign_key: :fk_registered_app_id

  # hooks to manipulate memcached
  after_save  :add_or_update_memcached
  after_destroy :remove_from_memcached, :add_or_update_memcached

  # method will return registered_app of validation
  def register_app
  	self.registered_app
  end

  # method will remove validations from memcached
  def remove_from_memcached
  	app = register_app
  	Memcached.delete_field_memcached("#{app.app_name}_fields")
  end

  # method will add or update validations in memcached
  def add_or_update_memcached
  	Memcached.set_field_memcached(register_app)
  end

end
