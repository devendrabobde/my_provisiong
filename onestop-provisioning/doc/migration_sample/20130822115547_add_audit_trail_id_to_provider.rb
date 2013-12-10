class AddAuditTrailIdToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :fk_audit_trail_id, :string
  end
end
