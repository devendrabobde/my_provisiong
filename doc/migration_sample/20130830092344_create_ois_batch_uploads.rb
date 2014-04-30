class CreateOisBatchUploads < ActiveRecord::Migration
  def change
    create_table(:ois_batch_uploads, id: false) do |t|
      t.string :sys_ois_batch_upload_id, limit: 50,  null: false, primary: true
      t.string :ois_batch_upload_id, limit: 50, null: false, unique: true
      t.string :ois_name
      t.string :ois_id
      t.string :ois_password

      # t.timestamps
    end
  end
end
