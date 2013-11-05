class RemoveProviderDefaultContraints < ActiveRecord::Migration
  def up
   change_column :providers, :username, :string, :null => true
   change_column :providers, :password, :string, :null => true
   change_column :providers, :role, :string, :null => true
   change_column :providers, :first_name, :string, :null => true
   change_column :providers, :last_name, :string, :null => true
   change_column :providers, :email, :string, :null => true
   change_column :providers, :phone, :string, :null => true
   change_column :providers, :department, :string, :null => true
  end

  def down
  end
end
