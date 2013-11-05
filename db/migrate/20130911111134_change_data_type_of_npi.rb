class ChangeDataTypeOfNpi < ActiveRecord::Migration
  def up
   change_column :providers, :npi, :string
  end

  def down
   change_column :providers, :npi, :integer
  end
end
