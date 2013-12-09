class RedisCache

  # Below method to update validations cached
  def self.update_validations_cached
  	# Pick register app in groups of 100
    RegisteredApp.find_in_batches(batch_size: 100) do |register_app_group|
      # pick each group
      register_app_group.each do |each_application|
  	  	# pick all validation from each app
  	  	value = each_application.app_upload_fields.includes(:app_upload_field_validations)
	      Rails.cache.write(each_application.app_name, value)
	  end # end each_application
    end # end register_app_group
  end # end of update_cached

  # Below method will get validation cached
  def self.get_validation_cached(application_name)
   	return Rails.cache.read(application_name)
  end # end of get_cached

  # Below method will set validation cached
  def self.set_validation_cached(application)
 	  value = application.app_upload_fields.includes(:app_upload_field_validations)
	  Rails.cache.write(application.app_name, value)
  end # end of get_cached

  # Below method will delete validation cached
  def self.delete_validation_cached(application_name)
  	Rails.cache.delete(application_name)
  end # end of delete_cached

end # end of class
