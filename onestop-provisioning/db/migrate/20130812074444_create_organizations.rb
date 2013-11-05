class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table(:organizations, id: false) do |t|
      t.string :sys_organization_id, limit: 50, null: false, primary: true
      t.string :organization_id, limit: 50, null: false, unique: true
      t.string :name

      # t.timestamps
    end
  end
end
