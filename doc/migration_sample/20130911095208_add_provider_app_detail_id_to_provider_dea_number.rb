class AddProviderAppDetailIdToProviderDeaNumber < ActiveRecord::Migration
  def change
   add_column :provider_dea_numbers, :fk_provider_app_detail_id, :string
  end
end
