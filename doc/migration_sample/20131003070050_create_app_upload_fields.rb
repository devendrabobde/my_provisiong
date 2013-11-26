class CreateAppUploadFields < ActiveRecord::Migration
  def change
    create_table(:app_upload_fields, id: false) do |t|
      t.string :sys_app_upload_field_id, limit: 50,  null: false, primary: true
      t.string :app_upload_field_id, limit: 50, null: false, unique: true
      t.string :fk_registered_app_id
      t.string :name
      t.string :field_type
      t.boolean :required, default: false

      # t.timestamps
    end
  end
end
