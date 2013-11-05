class CreateRegisteredApps < ActiveRecord::Migration
  def change
    create_table(:registered_apps, id: false) do |t|
      t.string :sys_registered_app_id, limit: 50, null: false, primary: true
      t.string :registered_app_id, limit: 50, null: false, unique: true
      t.string :app_name
      t.string :app_ois_url
      t.text :data_template

      # t.timestamps
    end
  end
end
