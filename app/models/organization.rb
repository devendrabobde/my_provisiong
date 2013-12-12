class Organization < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :name, :address1, :address2, :city, :state_code, :postal_code, :country_code,
                  :contact_first_name, :contact_last_name, :contact_phone, :contact_fax, :contact_email,
                  :deleted_at, :deleted_reason, :idp_vendor_id, :zip_code, :vendor_label, :vendor_node_label

  alias_attribute :sys_organization_id, :id

  #
  # Validations
  #

  EMAIL = /^.+@.+\..+$/.freeze
  PERSON_NAME  = /^[a-zA-Z'-]+$/.freeze

  validates :name, presence: true, :uniqueness => true
  validates :contact_first_name, :format => { :with => PERSON_NAME }
  validates :contact_last_name, :format => { :with => PERSON_NAME }
  validates :contact_email, :format => { :with => EMAIL }

  #
  # Scopes
  #
  default_scope { where(deleted_at: nil) }

  #
  # Associations
  #
  has_many :caos, foreign_key: :fk_organization_id
  has_many :audit_trails, foreign_key: :fk_organization_id
  has_many :provider_app_details, foreign_key: :fk_organization_id

  def is_active?
   !deleted_at
  end
end
