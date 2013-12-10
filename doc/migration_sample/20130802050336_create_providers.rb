class CreateProviders < ActiveRecord::Migration
  def change
    create_table(:providers, id: false) do |t|
      t.string :sys_provider_id, limit: 50, null: false, primary: true
      t.string :provider_id, limit: 50, null: false, unique: true
      t.string :username, null: false
      t.string :password, null: false
      t.string :role, null: false
      t.string :prefix
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.string :suffix
      t.text :degrees
      t.integer :npi
      t.date :birth_date
      t.string :email, null: false
      t.text :address_1
      t.text :address_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone, null: false
      t.string :fax
      t.string :department, null: false
    end
  end
end
