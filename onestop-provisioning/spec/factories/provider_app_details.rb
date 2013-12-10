FactoryGirl.define do
  factory :provider_app_detail do
    fk_cao_id 1
    fk_registered_app_id 1
    fk_audit_trail_id 1
    fk_organization_id 1
  end
end
