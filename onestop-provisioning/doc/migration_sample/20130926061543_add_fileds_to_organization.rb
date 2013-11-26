class AddFiledsToOrganization < ActiveRecord::Migration
  def change
   add_column :organizations, :vendor_label, :string
   add_column :organizations, :vendor_node_label, :string
  end
end
