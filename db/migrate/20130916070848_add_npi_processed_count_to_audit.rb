class AddNpiProcessedCountToAudit < ActiveRecord::Migration
  def change
   add_column :audit_trails, :total_npi_processed, :integer, :after => :total_providers
  end
end
