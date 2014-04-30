class CreateProviderDeaNumbers < ActiveRecord::Migration
  def change
    create_table(:provider_dea_numbers, id: false) do |t|
      t.string :sys_provider_dea_number_id, limit: 50,  null: false, primary: true
      t.string :provider_dea_number_id, limit: 50, null: false, unique: true
      t.string :provider_dea, :limit => 50
      t.string :provider_dea_state, :limit => 15
      t.date :provider_dea_expiration_date

      # t.timestamps
    end
  end
end
