FactoryGirl.define do
  factory :provider_dea_number do
    provider_dea "MyString"
    provider_dea_state "MyString"
    provider_dea_expiration_date "MyString"
    fk_provider_app_detail_id "MyString"
  end
end
