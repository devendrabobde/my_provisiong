class AddDisabledToAdmin < ActiveRecord::Migration
  def change
    add_column :admin_user, :disabled, :boolean, :default => false
    add_column :admin_user, :disabled_date, :timestamp
  end
end
