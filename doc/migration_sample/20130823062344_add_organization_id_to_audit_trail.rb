class AddOrganizationIdToAuditTrail < ActiveRecord::Migration
  def change
   add_column :audit_trails, :fk_organization_id, :string
  end
end
