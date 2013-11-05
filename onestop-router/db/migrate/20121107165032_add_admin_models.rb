class AddAdminModels < ActiveRecord::Migration
  include DrFirstMigrationHelpers

  def change
    create_onestop_table :organization do |t|
      t.string   :organization_name,  :limit => 150
      t.string   :address1,           :limit => 100
      t.string   :address2,           :limit => 100
      t.string   :city,               :limit => 100
      t.string   :state_code,         :limit => 2
      t.string   :postal_code,        :limit => 20
      t.string   :country_code,       :limit => 20,     :default => 'USA', :null => false
      t.string   :contact_first_name, :limit => 120,    :null => false
      t.string   :contact_last_name,  :limit => 120,    :null => false
      t.string   :contact_phone,      :limit => 20
      t.string   :contact_fax,        :limit => 20
      t.string   :contact_email,      :limit => 100
      t.string   :organization_npi,   :limit => 10
      t.boolean  :disabled,           :default => false
      t.timestamp :disabled_date
    end
    add_index :organization, :organization_npi, :unique => true

    create_onestop_table :ois_client do |t|
      t.string :client_password,           :limit => 80
      t.string :client_name,               :limit => 80
      t.string :ip_address_concat,         :limit => 50
      t.string :ois_client_preference_id,  :limit => 36
      t.string :slug,                      :null => false
      t.boolean   :disabled,               :default => false
      t.timestamp :disabled_date
    end
    add_index :ois_client, :slug, :unique => true

    create_onestop_table :ois_client_preference do |t|
      t.string :client_name,     :limit => 80
      t.string :preference_name, :limit => 80
      t.string :faq_url,         :limit => 1000
      t.string :help_url,        :limit => 1000
      t.string :logo_url,        :limit => 1000
      t.string :slug,            :null => false
    end
    add_index :ois_client_preference, :slug, :unique => true

    create_onestop_table :ois do |t|
      t.string :ois_name,                  :limit => 80
      t.string :ois_password,              :limit => 80
      t.string :ip_address_concat,         :limit => 50
      t.string :outgoing_service_id,       :limit => 80
      t.string :outgoing_service_password, :limit => 80
      t.string :enrollment_url,            :limit => 1000
      t.string :authentication_url,        :limit => 1000
      t.string :organization_id,           :limit => 36
      t.boolean :disabled,                 :default => false
      t.string  :slug,                      :null => false
      t.integer :idp_level
      t.timestamp :disabled_date
    end
    add_index :ois, :slug, :unique => true

    add_foreign_key :ois_client, :ois_client_preference, :column => :ois_client_preference_id

    create_onestop_table :performance_log do |t|
      t.string    :client_id,       :limit => 36
      t.string    :request_ip,      :limit => 20
      t.string    :request_content
      t.text      :request_params
      t.integer   :request_size
      t.timestamp :request_time
      t.text      :response_content
      t.timestamp :response_time
      t.integer   :response_size
      t.string    :controller_name
      t.string    :api_name
      t.string    :server_name,     :limit => 50
      t.string    :server_version,  :limit => 50
      t.string    :client_platform, :limit => 50
      t.string    :client_version,  :limit => 50
      t.string    :status
      t.string    :error_type
      t.string    :error_message,   :limit => 2000
    end

    add_index :performance_log, :client_id

    create_onestop_table :user do |t|
      t.string :npi,        :limit => 25, :null => false
      t.string :first_name, :limit => 80
      t.string :last_name,  :limit => 80
      t.boolean :enabled,   :default => true
    end

    add_index :user, :npi, :unique => true

    create_table :oises_users, :id => false do |t|
      t.string :ois_id,  :limit => 36
      t.string :user_id, :limit => 36
    end

    add_index :oises_users, [:ois_id, :user_id]
    add_index :oises_users, [:user_id, :ois_id]
  end
end
