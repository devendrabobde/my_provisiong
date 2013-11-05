class User < ActiveRecord::Base
  self.table_name = 'onestop_user'

  include Mixins::OneStop::Timestamps

  class UserError < OneStopRequestError; end

  InvalidRequest = UserError.error_type(code: 'invalid-request', message: 'Invalid User Request')
  NotFound       = UserError.error_type(code: 'not-found', message: 'User not found')
  NameMismatch   = UserError.error_type(code: 'npi-name-mismatch', message: 'NPI Name Mismatch')
  Invalid        = UserError.error_type(code: 'invalid-user', message: 'User is invalid')

  audited

  has_and_belongs_to_many :oises

  validates_uniqueness_of :npi

  validates_format_of :first_name, with: Formats::PERSON_NAME
  validates_format_of :last_name,  with: Formats::PERSON_NAME
  validates_format_of :npi,        with: Formats::NPI

  attr_accessible :npi, :first_name, :last_name, :enabled

  def self.find_by_npi!(requested_npi = nil)
    raise InvalidRequest unless requested_npi.present?
    user = where(:npi => requested_npi).first
    raise NotFound unless user
    user
  end

  def self.find_by_request(params)
    raise InvalidRequest unless valid_request_params?(params)
    user = where(:npi => params[:npi]).first
    raise NotFound unless user
    raise NameMismatch unless user.matches_request?(params)
    user
  end

  def matches_request?(request)
    first_name == request[:first_name] and last_name == request[:last_name]
  end

  private
    def self.valid_request_params?(params)
      keys = params.symbolize_keys.keys

      [:npi, :first_name, :last_name].all? { |key| keys.include?(key) }
    end
end