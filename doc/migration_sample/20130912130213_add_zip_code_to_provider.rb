class AddZipCodeToProvider < ActiveRecord::Migration
  def change
   add_column :providers, :zip, :string, :limit => 10
  end
end
