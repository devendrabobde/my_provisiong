class Organization < ActiveRecord::Base
  include Mixins::OneStop::Timestamps
  include Mixins::OneStop::DisabledDate

  self.table_name = "onestop_organization"

  audited

  validates :country_code, :presence => true

  validates_format_of :contact_first_name, with: Formats::PERSON_NAME
  validates_format_of :contact_last_name,  with: Formats::PERSON_NAME
  validates_format_of :organization_name,  with: Formats::SERVICE_NAME
  validates_format_of :organization_npi,   with: Formats::NPI

  validates :organization_npi, :uniqueness => true

  attr_accessible :organization_npi, :organization_name, :address1, :address2,
                  :city, :state_code, :postal_code, :country_code,
                  :contact_first_name, :contact_last_name, :contact_phone,
                  :contact_fax, :contact_email, :disabled

  def display_name
    organization_name
  end
end
