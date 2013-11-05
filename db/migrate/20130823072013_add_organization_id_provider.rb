class AddOrganizationIdProvider < ActiveRecord::Migration
  def up
   add_column :providers, :fk_organization_id, :string
  end

  def down
   remove_column :providers, :fk_organization_id, :string
  end
end
