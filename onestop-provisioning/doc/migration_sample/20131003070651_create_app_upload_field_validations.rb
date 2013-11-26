class CreateAppUploadFieldValidations < ActiveRecord::Migration
  def change
    create_table(:app_upload_field_validations, id: false)  do |t|
      t.string :sys_app_field_validation_id, limit: 50,  null: false, primary: true
      t.string :app_field_validation_id, limit: 50, null: false, unique: true
      t.string :fk_app_upload_field_id
      t.string :validation
      t.text :error_message

      # t.timestamps
    end
  end
end
