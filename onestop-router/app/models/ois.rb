class Ois < ActiveRecord::Base
  self.table_name = "onestop_ois"

  include Mixins::OneStop::Timestamps
  include Mixins::OneStop::DisabledDate
  extend FriendlyId

  friendly_id :ois_name, :use => :slugged

  audited

  Unauthorized = OneStopRequestError.error_type(code: 'unauthorized', message: 'Unauthorized OIS')

  has_many                :ois_user_tokens
  has_and_belongs_to_many :users
  belongs_to              :organization

  before_validation :set_default_password, :on => :create

  validates_presence_of  :outgoing_service_id, :outgoing_service_password, :organization

  validates_format_of :ois_name,           with: Formats::SERVICE_NAME
  validates_format_of :ois_password,       with: Formats::PASSWORD
  validates_format_of :enrollment_url,     with: Formats::URL
  validates_format_of :authentication_url, with: Formats::URL
  validates_format_of :idp_level,          with: Formats::IDP_LEVEL
  validates_format_of :slug,               with: Formats::SLUG

  validates_uniqueness_of :ois_name
  validates_length_of :ois_password, in: Password::LENGTH_RANGE

  attr_accessible :ois_name, :ois_password, :outgoing_service_id,
                  :outgoing_service_password, :enrollment_url,
                  :authentication_url, :organization_id, :idp_level,
                  :disabled, :ip_address_concat

  def self.authenticate(slug, password)
    raise Unauthorized unless slug.present? and password.present?
    ois = find_by_slug_and_ois_password(slug, password)

    raise Unauthorized if !ois || ois.disabled?

    ois
  end

  def self.with_min_idp_level(min_idp_level)
    return [] unless min_idp_level.present?
    where("idp_level >= ?", min_idp_level)
  end

  def view_user(user = nil)
    user_data = {}
    user_data = {
      first_name: user.first_name,
      last_name: user.last_name,
      npi: user.npi
    } if user

    user_data.merge(ois_details)
  end

  private
    def set_default_password
      self.ois_password = Password.new if self.ois_password.blank?
    end

    def ois_details
      {
        ois_params: {
          city:              organization.city,
          country:           organization.country_code,
          email_address:     organization.contact_email,
          fax_number:        organization.contact_fax,
          phone_number:      organization.contact_phone,
          postal_code:       organization.postal_code,
          state_code:        organization.state_code,
          street_address_1:  organization.address1,
          street_address_2:  organization.address2
        },
        ois_slug: self.slug
      }
    end
end
