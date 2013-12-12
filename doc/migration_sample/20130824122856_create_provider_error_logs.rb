class CreateProviderErrorLogs < ActiveRecord::Migration
  def change
    create_table(:provider_error_logs, id: false) do |t|
      t.string :sys_provider_error_log_id, limit: 50,  null: false, primary: true
      t.string :provider_error_log_id, limit: 50, null: false, unique: true
      t.string :fk_provider_id
      t.string :application_name
      t.text :error_message
      # t.timestamps
    end
  end
end
