class AppUploadField < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :fk_registered_app_id, :name, :field_type, :required, :display_name

  alias_attribute :sys_app_upload_field_id, :id

  #
  # Associations
  #
  has_many :app_upload_field_validations, foreign_key: :fk_app_upload_field_id, dependent: :destroy
  belongs_to :registered_app, foreign_key: :fk_registered_app_id

  # hooks to manipulate cached
  after_save  :add_or_update_cached
  after_destroy :remove_from_cached, :add_or_update_cached

  # method will return registered_app of validation
  def register_app
  	self.registered_app
  end

  # method will remove validations from cached
  def remove_from_cached
    app = register_app
    RedisCache.delete_validation_cached(app.app_name)
  end

  # method will add or update validations in cached
  def add_or_update_cached
    RedisCache.set_validation_cached(register_app)
  end

end
