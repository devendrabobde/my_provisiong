class DeviseCreateAdminUsers < ActiveRecord::Migration
  include DrFirstMigrationHelpers

  def migrate(direction)
    super
  end

  def change
    create_onestop_table(:admin_user) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => "", :limit => 100
      t.string :encrypted_password, :null => false, :default => "", :limit => 100

      ## Recoverable
      t.string   :reset_password_token
      t.timestamp :reset_password_sent_at

      ## Rememberable
      t.timestamp :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.timestamp :current_sign_in_at
      t.timestamp :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token

      t.timestamps
    end

    add_index :admin_user, :email,                :unique => true
    add_index :admin_user, :reset_password_token, :unique => true
    # add_index :admin_users, :confirmation_token,   :unique => true
    # add_index :admin_users, :unlock_token,         :unique => true
    # add_index :admin_users, :authentication_token, :unique => true
  end
end
