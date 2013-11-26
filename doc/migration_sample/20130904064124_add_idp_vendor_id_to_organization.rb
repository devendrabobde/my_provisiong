class AddIdpVendorIdToOrganization < ActiveRecord::Migration
  def change
   add_column :organizations, :idp_vendor_id, :string
  end
end
