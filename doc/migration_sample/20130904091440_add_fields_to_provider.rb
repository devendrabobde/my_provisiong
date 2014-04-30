class AddFieldsToProvider < ActiveRecord::Migration
  def change
 add_column :providers, :provider_otp_token_serial, :string, :limit => 35
 add_column :providers, :resend_flag, :string, :limit => 1, :default => 'n'
 add_column :providers, :hospital_admin_first_name, :string, :limit => 50
 add_column :providers, :hospital_admin_last_name, :string, :limit => 50
 add_column :providers, :idp_performed_date, :date
 add_column :providers, :idp_performed_time, :timestamp
 add_column :providers, :hospital_idp_transaction_id, :string, :limit => 35
  end
end
