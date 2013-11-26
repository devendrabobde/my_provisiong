class CreateProfiles < ActiveRecord::Migration
  def change
    create_table(:profiles, id: false) do |t|
      t.string :sys_profile_id, limit: 50, null: false, primary: true
      t.string :profile_id, limit: 50, null: false, unique: true
      t.string :profile_name

      # t.timestamps
    end
  end
end
