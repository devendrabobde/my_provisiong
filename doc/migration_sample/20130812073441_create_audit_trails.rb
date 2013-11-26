class CreateAuditTrails < ActiveRecord::Migration
  def change
    create_table(:audit_trails, id: false) do |t|
      t.string :sys_audit_trail_id, limit: 50, null: false, primary: true
      t.string :audit_trail_id, limit: 50, null: false, unique: true
      t.string :file_name
      t.string :fk_registered_app_id
      t.integer :total_providers
      t.string :file_url
      t.date :created_date
      t.string :status
      t.string :fk_cao_id

      # t.timestamps
    end
  end
end
