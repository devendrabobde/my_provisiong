class AddDeletedReasonToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :deleted_reason, :string
  end
end
