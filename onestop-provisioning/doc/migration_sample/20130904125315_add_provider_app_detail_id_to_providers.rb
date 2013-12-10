class AddProviderAppDetailIdToProviders < ActiveRecord::Migration
  def change
   add_column :providers, :fk_provider_app_detail_id, :string
  end
end
