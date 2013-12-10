class CreateProviderAppDetails < ActiveRecord::Migration
  def change
    create_table(:provider_app_details, id: false) do |t|
      t.string :sys_provider_app_detail_id, limit: 50,  null: false, primary: true
      t.string :provider_app_detail_id, limit: 50, null: false, unique: true
      t.string :status_code
      t.text :status_text
      t.string :fk_cao_id
      t.string :fk_registered_app_id
      t.string :fk_audit_trail_id
      t.string :fk_organization_id

      # t.timestamps
    end
  end
end
