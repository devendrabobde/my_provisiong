class CreateIdTokens < ActiveRecord::Migration
  include DrFirstMigrationHelpers

  def change
    create_onestop_table :ois_user_token do |t|
      t.string    :ois_id,  :limit => 36, :null => false
      t.string    :user_id, :limit => 36, :null => false
      t.string    :token
      t.timestamp :verified_timestamp
    end

    add_index :ois_user_token, :ois_id
    add_index :ois_user_token, :token, :unique => true
  end
end
