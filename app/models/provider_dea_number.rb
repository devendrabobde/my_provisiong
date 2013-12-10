class ProviderDeaNumber < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :fk_provider_app_detail_id, :provider_dea, :provider_dea_state, :provider_dea_expiration_date

  alias_attribute :sys_provider_dea_number_id, :id

  belongs_to :provider_app_detail, foreign_key: :fk_provider_app_detail_id

end
