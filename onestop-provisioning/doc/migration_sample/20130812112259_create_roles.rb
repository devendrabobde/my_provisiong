class CreateRoles < ActiveRecord::Migration
  def change
    create_table(:roles, id: false) do |t|
      t.string :sys_role_id, limit: 50, null: false, primary: true
      t.string :role_id, limit: 50, null: false, unique: true
      t.string :name

      # t.timestamps
    end
  end
end
