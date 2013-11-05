class AddDisplayNameToAppUploadField < ActiveRecord::Migration
  def change
    add_column :app_upload_fields, :display_name, :string
  end
end
