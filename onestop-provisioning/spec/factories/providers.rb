FactoryGirl.define do
  factory :provider do
    username "testuser"
    password "1234567"
    role "mystring"
    prefix "mystring"
    first_name "mystring"
    middle_name "mystring"
    last_name "mystring"
    suffix "mystring"
    degrees "mystring"
    npi "9632587412"
    birth_date "2013-06-12"
    email "testuser3@example.com"
    address_1 "mystring"
    address_2 "mystring"
    city "mystring"
    state "mystring"
    postal_code 123654
    phone 1265436
    fax 1236489
    department "mystring"
    provider_otp_token_serial "mystring"
    resend_flag "m"
    hospital_admin_first_name "mystring"
    hospital_admin_last_name "mystring"
    idp_performed_date "2013-07-17"
    idp_performed_time "18:58:58"
    hospital_idp_transaction_id 1
    fk_provider_app_detail_id 1
    zip 123664
  end
end
