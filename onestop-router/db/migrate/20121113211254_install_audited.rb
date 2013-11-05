class InstallAudited < ActiveRecord::Migration
  def self.up
    create_table :audit, :force => true do |t|
      t.column :auditable_id, :string, :limit => 36
      t.column :auditable_type, :string
      t.column :associated_id, :string, :limit => 36
      t.column :associated_type, :string
      t.column :user_id, :string, :limit => 36
      t.column :user_type, :string
      t.column :username, :string
      t.column :action, :string
      t.column :audited_changes, :text
      t.column :version, :integer, :default => 0
      t.column :comment, :string
      t.column :remote_address, :string
      t.column :created_at, :timestamp
    end

    add_index :audit, [:auditable_id, :auditable_type], :name => 'auditable_index'
    add_index :audit, [:associated_id, :associated_type], :name => 'associated_index'
    add_index :audit, [:user_id, :user_type], :name => 'user_index'
    add_index :audit, :created_at
  end

  def self.down
    drop_table :audit
  end
end
