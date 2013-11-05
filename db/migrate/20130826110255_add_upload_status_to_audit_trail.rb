class AddUploadStatusToAuditTrail < ActiveRecord::Migration
  def change
   add_column :audit_trails, :upload_status, :boolean, default: false
  end
end
