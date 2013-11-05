class AddUserNameToUser < ActiveRecord::Migration
  def change
    add_column :admin_user, :user_name, :string, :limit => 120
    add_index :admin_user, :user_name, :unique => true
  end
end
