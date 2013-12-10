class ChangeDataTypeForIsactive < ActiveRecord::Migration
  def change
   change_column :caos, :is_active, :boolean
  end
end
