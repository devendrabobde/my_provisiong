class AddFormatFieldToAppUploadFieldValidation < ActiveRecord::Migration
  def change
   add_column :app_upload_field_validations, :field_format, :string
  end
end
