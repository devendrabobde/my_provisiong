class AddFieldToProviderErrorLog < ActiveRecord::Migration
  def change
   add_column :provider_error_logs, :fk_cao_id, :string
  end
end
