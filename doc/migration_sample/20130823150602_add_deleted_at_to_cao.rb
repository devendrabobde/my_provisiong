class AddDeletedAtToCao < ActiveRecord::Migration
  def change
   add_column :caos, :deleted_at, :datetime
  end
end
