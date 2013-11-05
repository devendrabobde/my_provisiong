class AddFieldsToOrganization < ActiveRecord::Migration
  def change
   add_column :organizations, :address1, :string, :limit => 100
   add_column :organizations, :address2, :string, :limit => 100
   add_column :organizations, :city, :string, :limit => 100
   add_column :organizations, :state_code, :string
   add_column :organizations, :postal_code, :string, :limit => 20
   add_column :organizations, :country_code, :string,  :limit => 20
   add_column :organizations, :contact_first_name, :string, :limit => 120
   add_column :organizations, :contact_last_name, :string, :limit => 120
   add_column :organizations, :contact_phone, :string, :limit => 20
   add_column :organizations, :contact_fax, :string, :limit => 20
   add_column :organizations, :contact_email, :string, :limit => 100
  end
end
