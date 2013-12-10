class AddZipToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :zip_code, :string, :after => :state_code
  end
end
