FactoryGirl.define do
  factory :provider_dea_number do
    provider_dea "FM1859860"
    provider_dea_state "MD"
    provider_dea_expiration_date "03/01/1988"
    fk_provider_app_detail_id 1
  end
end
