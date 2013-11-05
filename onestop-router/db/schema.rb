# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130118201257) do

  create_table "admin_user", :force => true do |t|
    t.string    "email",                    :limit => 100,                                :default => "",    :null => false
    t.string    "encrypted_password",       :limit => 100,                                :default => "",    :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at",   :limit => 6
    t.timestamp "remember_created_at",      :limit => 6
    t.integer   "sign_in_count",                           :precision => 38, :scale => 0, :default => 0
    t.timestamp "current_sign_in_at",       :limit => 6
    t.timestamp "last_sign_in_at",          :limit => 6
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.datetime  "created_at",                                                                                :null => false
    t.datetime  "updated_at",                                                                                :null => false
    t.string    "creatorid",                :limit => 36
    t.string    "lastupdateid",             :limit => 36
    t.timestamp "createddate",              :limit => 6
    t.timestamp "lastupdatedate",           :limit => 6
    t.virtual   "createddate_as_number",                   :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",                :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
    t.boolean   "disabled",                                :precision => 1,  :scale => 0, :default => false
    t.timestamp "disabled_date",            :limit => 6
    t.string    "user_name",                :limit => 120
  end

  add_index "admin_user", ["email"], :name => "i_onestop_admin_user_email", :unique => true
  add_index "admin_user", ["reset_password_token"], :name => "i_one_adm_use_res_pas_tok", :unique => true
  add_index "admin_user", ["user_name"], :name => "i_onestop_admin_user_user_name", :unique => true

  create_table "audit", :force => true do |t|
    t.string    "auditable_id",    :limit => 36
    t.string    "auditable_type"
    t.string    "associated_id",   :limit => 36
    t.string    "associated_type"
    t.string    "user_id",         :limit => 36
    t.string    "user_type"
    t.string    "username"
    t.string    "action"
    t.text      "audited_changes"
    t.integer   "version",                       :precision => 38, :scale => 0, :default => 0
    t.string    "comment"
    t.string    "remote_address"
    t.timestamp "created_at",      :limit => 6
  end

  add_index "audit", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audit", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audit", ["created_at"], :name => "i_onestop_audit_created_at"
  add_index "audit", ["user_id", "user_type"], :name => "user_index"

  create_table "ois", :force => true do |t|
    t.string    "ois_name",                  :limit => 80
    t.string    "ois_password",              :limit => 80
    t.string    "ip_address_concat",         :limit => 50
    t.string    "outgoing_service_id",       :limit => 80
    t.string    "outgoing_service_password", :limit => 80
    t.string    "enrollment_url",            :limit => 1000
    t.string    "authentication_url",        :limit => 1000
    t.string    "organization_id",           :limit => 36
    t.boolean   "disabled",                                  :precision => 1,  :scale => 0, :default => false
    t.string    "slug",                                                                                        :null => false
    t.integer   "idp_level",                                 :precision => 38, :scale => 0
    t.timestamp "disabled_date",             :limit => 6
    t.string    "creatorid",                 :limit => 36
    t.string    "lastupdateid",              :limit => 36
    t.timestamp "createddate",               :limit => 6
    t.timestamp "lastupdatedate",            :limit => 6
    t.virtual   "createddate_as_number",                     :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",                  :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
  end

  add_index "ois", ["slug"], :name => "index_onestop_ois_on_slug", :unique => true

  create_table "ois_client", :force => true do |t|
    t.string    "client_password",          :limit => 80
    t.string    "client_name",              :limit => 80
    t.string    "ip_address_concat",        :limit => 50
    t.string    "ois_client_preference_id", :limit => 36
    t.string    "slug",                                                                                     :null => false
    t.boolean   "disabled",                               :precision => 1,  :scale => 0, :default => false
    t.timestamp "disabled_date",            :limit => 6
    t.string    "creatorid",                :limit => 36
    t.string    "lastupdateid",             :limit => 36
    t.timestamp "createddate",              :limit => 6
    t.timestamp "lastupdatedate",           :limit => 6
    t.virtual   "createddate_as_number",                  :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",               :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
  end

  add_index "ois_client", ["slug"], :name => "i_onestop_ois_client_slug", :unique => true

  create_table "ois_client_preference", :force => true do |t|
    t.string    "client_name",              :limit => 80
    t.string    "preference_name",          :limit => 80
    t.string    "faq_url",                  :limit => 1000
    t.string    "help_url",                 :limit => 1000
    t.string    "logo_url",                 :limit => 1000
    t.string    "slug",                                                                    :null => false
    t.string    "creatorid",                :limit => 36
    t.string    "lastupdateid",             :limit => 36
    t.timestamp "createddate",              :limit => 6
    t.timestamp "lastupdatedate",           :limit => 6
    t.virtual   "createddate_as_number",                    :precision => 38, :scale => 0,                 :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",                 :precision => 38, :scale => 0,                 :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
  end

  add_index "ois_client_preference", ["slug"], :name => "i_one_ois_cli_pre_slu", :unique => true

  create_table "ois_user_token", :force => true do |t|
    t.string    "ois_id",                   :limit => 36,                                :null => false
    t.string    "user_id",                  :limit => 36,                                :null => false
    t.string    "token"
    t.timestamp "verified_timestamp",       :limit => 6
    t.string    "creatorid",                :limit => 36
    t.string    "lastupdateid",             :limit => 36
    t.timestamp "createddate",              :limit => 6
    t.timestamp "lastupdatedate",           :limit => 6
    t.virtual   "createddate_as_number",                  :precision => 38, :scale => 0,                 :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",               :precision => 38, :scale => 0,                 :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
  end

  add_index "ois_user_token", ["ois_id"], :name => "i_one_ois_use_tok_ois_id"
  add_index "ois_user_token", ["token"], :name => "i_onestop_ois_user_token_token", :unique => true

  create_table "oises_users", :id => false, :force => true do |t|
    t.string "ois_id",  :limit => 36
    t.string "user_id", :limit => 36
  end

  add_index "oises_users", ["ois_id", "user_id"], :name => "i_one_ois_use_ois_id_use_id"
  add_index "oises_users", ["user_id", "ois_id"], :name => "i_one_ois_use_use_id_ois_id"

  create_table "organization", :force => true do |t|
    t.string    "organization_name",        :limit => 150
    t.string    "address1",                 :limit => 100
    t.string    "address2",                 :limit => 100
    t.string    "city",                     :limit => 100
    t.string    "state_code",               :limit => 2
    t.string    "postal_code",              :limit => 20
    t.string    "country_code",             :limit => 20,                                 :default => "USA", :null => false
    t.string    "contact_first_name",       :limit => 120,                                                   :null => false
    t.string    "contact_last_name",        :limit => 120,                                                   :null => false
    t.string    "contact_phone",            :limit => 20
    t.string    "contact_fax",              :limit => 20
    t.string    "contact_email",            :limit => 100
    t.string    "organization_npi",         :limit => 10
    t.boolean   "disabled",                                :precision => 1,  :scale => 0, :default => false
    t.timestamp "disabled_date",            :limit => 6
    t.string    "creatorid",                :limit => 36
    t.string    "lastupdateid",             :limit => 36
    t.timestamp "createddate",              :limit => 6
    t.timestamp "lastupdatedate",           :limit => 6
    t.virtual   "createddate_as_number",                   :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",                :precision => 38, :scale => 0,                                    :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
  end

  add_index "organization", ["organization_npi"], :name => "i_one_org_org_npi", :unique => true

  create_table "performance_log", :force => true do |t|
    t.string    "client_id",                :limit => 36
    t.string    "request_ip",               :limit => 20
    t.string    "request_content"
    t.text      "request_params"
    t.integer   "request_size",                             :precision => 38, :scale => 0
    t.timestamp "request_time",             :limit => 6
    t.text      "response_content"
    t.timestamp "response_time",            :limit => 6
    t.integer   "response_size",                            :precision => 38, :scale => 0
    t.string    "controller_name"
    t.string    "api_name"
    t.string    "server_name",              :limit => 50
    t.string    "server_version",           :limit => 50
    t.string    "client_platform",          :limit => 50
    t.string    "client_version",           :limit => 50
    t.string    "status"
    t.string    "error_type"
    t.string    "error_message",            :limit => 2000
    t.string    "creatorid",                :limit => 36
    t.string    "lastupdateid",             :limit => 36
    t.timestamp "createddate",              :limit => 6
    t.timestamp "lastupdatedate",           :limit => 6
    t.virtual   "createddate_as_number",                    :precision => 38, :scale => 0, :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",                 :precision => 38, :scale => 0, :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
  end

  add_index "performance_log", ["client_id"], :name => "i_one_per_log_cli_id"

  create_table "user", :force => true do |t|
    t.string    "npi",                      :limit => 25,                                                  :null => false
    t.string    "first_name",               :limit => 80
    t.string    "last_name",                :limit => 80
    t.boolean   "enabled",                                :precision => 1,  :scale => 0, :default => true
    t.string    "creatorid",                :limit => 36
    t.string    "lastupdateid",             :limit => 36
    t.timestamp "createddate",              :limit => 6
    t.timestamp "lastupdatedate",           :limit => 6
    t.virtual   "createddate_as_number",                  :precision => 38, :scale => 0,                                   :as => "TO_NUMBER(TO_CHAR(\"CREATEDDATE\",'yyyymmddhh24miss'))",    :type => :integer
    t.virtual   "lastupdatedate_as_number",               :precision => 38, :scale => 0,                                   :as => "TO_NUMBER(TO_CHAR(\"LASTUPDATEDATE\",'yyyymmddhh24miss'))", :type => :integer
  end

  add_index "user", ["npi"], :name => "index_onestop_user_on_npi", :unique => true

  add_foreign_key "ois_client", "ois_client_preference", :column => "ois_client_preference_id", :name => "one_ois_cli_ois_cli_pre_id_fk"

end
