class Memcached

  # Below method to update validations memcached
  def self.update_validations_memcached
  	# Pick register app in groups of 100
    RegisteredApp.find_in_batches(batch_size: 100) do |register_app_group|
      # pick each group
      register_app_group.each do |each_application|
  	  	# pick all validation from each app
  	  	value = each_application.app_upload_fields.includes(:app_upload_field_validations).where("required =? ", 1).all
	      $memcached.set(each_application.app_name, value)
	  end # end each_application
    end # end register_app_group
  end # end of update_memcached

  # Below method will get validation memcached
  def self.get_validation_memcached(application_name)
   	return $memcached.get(application_name)
  end # end of get_memcached

  # Below method will set validation memcached
  def self.set_validation_memcached(application)
 	  value = application.app_upload_fields.includes(:app_upload_field_validations).where("required =? ", 1).all
	  $memcached.set(application.app_name, value)
  end # end of get_memcached

  # Below method will delete validation memcached
  def self.delete_validation_memcached(application_name)
  	$memcached.delete(application_name)
  end # end of delete_memcached

  # Below method to update fields memcached
  def self.update_fields_memcached
    # Pick register app in groups of 100
    RegisteredApp.find_in_batches(batch_size: 100) do |register_app_group|
      # pick each group
      register_app_group.each do |each_application|
        # pick all fields from each app
        value = each_application.app_upload_fields
        $memcached.set("#{each_application.app_name}_fields", value)
    end # end each_application
    end # end register_app_group
  end # end of update_memcached

  # Below method will get fields memcached
  def self.get_field_memcached(application_name)
    return $memcached.get(application_name)
  end

  # Below method will set fields memcached
  def self.set_field_memcached(application)
    value = application.app_upload_fields
    $memcached.set("#{application.app_name}_fields",value)
  end

  # Below method will delete fields memcached
  def self.delete_field_memcached(application_name)
    $memcached.delete(application_name)
  end # end of delete_memcached

  
end # end of class
