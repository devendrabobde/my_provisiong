class RemoveFieldsFromProviders < ActiveRecord::Migration
  def up
    remove_column :providers, :fk_cao_id
   remove_column :providers, :fk_registered_app_id
   remove_column :providers, :fk_audit_trail_id
   remove_column :providers, :fk_organization_id
  end

  def down
   add_column :providers, :fk_cao_id
   add_column :providers, :fk_registered_app_id
   add_column :providers, :fk_audit_trail_id
   add_column :providers, :fk_organization_id
  end
end
