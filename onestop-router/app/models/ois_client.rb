class OisClient < ActiveRecord::Base
  self.table_name = 'onestop_ois_client'

  extend FriendlyId
  include Mixins::OneStop::Timestamps
  include Mixins::OneStop::DisabledDate

  friendly_id :client_name, :use => :slugged

  Unauthorized = OneStopRequestError.error_type(code: 'unauthorized', message: 'Unauthorized Client account')

  belongs_to :ois_client_preference

  before_validation :set_default_password, :on => :create
  before_save   :set_default_ois_client_preference

  validates_presence_of :client_name, :slug
  validates_length_of :client_password, :in => Password::LENGTH_RANGE

  validates_format_of :client_name, with: Formats::SERVICE_NAME
  validates_format_of :client_password, with: Formats::PASSWORD

  audited :associated_with => :ois_client_preference

  attr_accessible :client_name, :client_password, :ip_address_concat, :ois_client_preference_id, :disabled

  def self.authenticate(name, password)
    raise Unauthorized unless name.present? and password.present?
    client = find_by_client_name_and_client_password(name, password)

    raise Unauthorized if !client || client.disabled?

    client
  end

  private
    def set_default_password
      self.client_password = Password.new if self.client_password.blank?
    end

    def set_default_ois_client_preference
      self.ois_client_preference = OisClientPreference.default unless self.ois_client_preference.present?
    end
end
