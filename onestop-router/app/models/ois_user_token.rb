class OisUserToken < ActiveRecord::Base
  self.table_name = 'onestop_ois_user_token'

  include Mixins::OneStop::Timestamps
  class OisUserTokenError < OneStopRequestError; end

  AlreadyVerified = OisUserTokenError.error_type(code: 'verified-id-token', message: 'Token previously used for validation')
  Expired         = OisUserTokenError.error_type(code: 'expired-id-token', message: 'Token expired')
  Invalid         = OisUserTokenError.error_type(code: 'invalid-id-token', message: 'Token is invalid')
  InvalidRequest  = OisUserTokenError.error_type(code: 'invalid-request', message: 'Token is required')
  NotFound        = OisUserTokenError.error_type(code: 'not-found', message: 'Token not found')

  audited

  belongs_to :user
  belongs_to :ois

  delegate :idp_level, :to => :ois
  delegate :first_name, :last_name, :npi, :to => :user

  before_create :generate_token

  validates_format_of :token, with: Formats::PASSWORD, on: :update

  attr_accessible :ois_id, :user_id, :token

  def self.verify_token!(token = nil)
    raise InvalidRequest unless token.present?

    id_token = self.find_by_token(token)
    raise NotFound unless id_token
    raise Expired if id_token.expired?
    raise AlreadyVerified if id_token.verified?

    id_token.verified_timestamp = Time.now
    id_token.save!
    id_token
  end

  def verified?
    self.verified_timestamp.present?
  end

  def expired?
    self.createddate < expires_at
  end

  private
    def generate_token
      self.token = Password.new
      generate_token unless OisUserToken.find_by_token(self.token).nil?
    end

    def expires_at
      server_configuration[:tokens_expire_in].to_i.seconds.ago
    end

    def server_configuration
      @server_configuration ||= YAML.load(File.read"#{Rails.root}/config/server.yml")[Rails.env].symbolize_keys
    end
end
