class AddEmailToCao < ActiveRecord::Migration
  def change
   # add_column :caos, :email, :string, :after => :last_name
   add_column :caos, :username, :string, :after => :email
  end
end
