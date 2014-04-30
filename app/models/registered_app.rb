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


  # Method which return application name in the "DrFirst - EPCSIDP" format
  def registered_app_name
    app = nil
    $regapps.each do |application|
      app = application.keys.first if !application.values.flatten.map{|val| display_name if val["ois_name"] == display_name}.delete_if{|x| x.nil?}.blank?
    end
    # app= $regapps.each{|f| f if f["ois_name"] == app_name}.first
  	app + " - " + display_name if app.present?  
  end
end