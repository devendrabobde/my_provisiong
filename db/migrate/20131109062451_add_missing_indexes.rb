class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :providers, :fk_provider_app_detail_id
    add_index :provider_dea_numbers, :fk_provider_app_detail_id
    add_index :app_upload_field_validations, :fk_app_upload_field_id
    add_index :audit_trails, :fk_cao_id
    add_index :audit_trails, :fk_registered_app_id
    add_index :audit_trails, :fk_organization_id
    add_index :provider_app_details, :fk_cao_id
    add_index :provider_app_details, :fk_registered_app_id
    add_index :provider_app_details, :fk_audit_trail_id
    add_index :provider_app_details, :fk_organization_id
    add_index :caos, :fk_profile_id
    add_index :caos, :fk_organization_id
    add_index :caos, :fk_role_id
    add_index :app_upload_fields, :fk_registered_app_id
    add_index :provider_error_logs, :fk_provider_id
    add_index :provider_error_logs, :fk_cao_id
    add_index :provider_error_logs, :fk_audit_trail_id
  end
end