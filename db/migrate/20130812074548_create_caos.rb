class CreateCaos < ActiveRecord::Migration
  def change
    create_table(:caos, id: false) do |t|
      t.string :sys_cao_id, limit: 50, null: false, primary: true
      t.string :cao_id, limit: 50, null: false, unique: true
      t.string :user_id
      t.string :first_name
      t.string  :last_name
      t.string :is_active
      t.string :fk_organization_id
      t.string :fk_profile_id
    end
  end
end
