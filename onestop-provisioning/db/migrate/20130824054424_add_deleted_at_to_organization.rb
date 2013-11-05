class AddDeletedAtToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :deleted_at, :datetime
    add_column :caos, :deleted_reason, :string
  end
end
