class AddRegisteredAppIdToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :fk_registered_app_id, :string
  end
end
