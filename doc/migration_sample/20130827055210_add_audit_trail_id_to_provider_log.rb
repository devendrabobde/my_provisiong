class AddAuditTrailIdToProviderLog < ActiveRecord::Migration
  def change
   add_column :provider_error_logs, :fk_audit_trail_id, :string
   change_column :audit_trails, :total_providers, :string
  end
end
