class OisClientPreference < ActiveRecord::Base
  self.table_name = 'onestop_ois_client_preference'
  include Mixins::OneStop::Timestamps

  DEFAULT_SLUG = 'onestop-default'

  extend FriendlyId
  friendly_id :preference_name, :use => :slugged

  has_many :ois_clients

  before_save :set_default_client_name
  before_destroy :update_clients_with_default_label

  validates_format_of :preference_name, with: Formats::SERVICE_NAME
  validates_format_of :faq_url,         with: Formats::URL
  validates_format_of :help_url,        with: Formats::URL
  validates_format_of :logo_url,        with: Formats::URL

  validates_uniqueness_of :preference_name

  attr_accessible :preference_name, :faq_url, :help_url, :logo_url

  audited
  has_associated_audits

  def self.default
    find_by_slug(DEFAULT_SLUG)
  end

  def created_date
    createddate
  end

  def last_update_date
    lastupdatedate
  end

  def to_s
    preference_name
  end

  private
  def update_clients_with_default_label
    default_ois_client_preference = OisClientPreference.find_by_slug(DEFAULT_SLUG)
    self.ois_clients.update_all :ois_client_preference_id => default_ois_client_preference.id
  end

  def set_default_client_name
    client = ois_clients.reload.first
    self.client_name ||= client.client_name if client.present?
  end
end
