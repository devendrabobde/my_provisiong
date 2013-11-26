class AddRoleFieldToCao < ActiveRecord::Migration
  def change
   add_column :caos, :fk_role_id, :string, :after => :username
  end
end
