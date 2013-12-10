class AddCoaIdToProvider < ActiveRecord::Migration
  def change
   add_column :providers, :fk_cao_id, :string
  end
end
