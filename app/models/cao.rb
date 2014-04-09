class Cao < ActiveRecord::Base

  include Extensions::UUID

  #attr_accessor :current_password

  devise :database_authenticatable, :recoverable, :validatable, :timeoutable, :registerable, :password_archivable,
         :rememberable, :trackable, :authentication_keys => [:username]

  attr_accessible :username, :first_name, :last_name, :user_id, :is_active,
                  :email, :password, :password_confirmation, :remember_me, :fk_organization_id,
                  :fk_profile_id, :fk_role_id, :deleted_reason, :deleted_at#, :encrypted_password, :password_salt

  alias_attribute :sys_cao_id, :id

  #
  # Validations
  #
  EMAIL = /^.+@.+\..+$/.freeze
  PERSON_NAME  = /^[a-zA-Z'-]+$/.freeze
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, :format => { :with => EMAIL }
  validates :first_name, :last_name, presence: true
  validate :password_complexity


  #
  # Association
  #
  has_many :audit_trails, foreign_key: :fk_cao_id
  belongs_to :profile, foreign_key: :fk_profile_id
  belongs_to :organization, foreign_key: :fk_organization_id
  belongs_to :role, foreign_key: :fk_role_id
  has_many :provider_error_logs, foreign_key: :fk_cao_id
  has_many :provider_app_details, foreign_key: :fk_cao_id

  after_create :send_welcome_email

  def is_admin?
    if role.name == "Admin"
      return true
    end
    false
  end

  def full_name
    first_name + " " + last_name
  end

  def active_for_authentication?
    super && !deleted_at
  end

  private
  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[0-9])(?=.*[!@$#%^&*])[a-zA-Z0-9!@$#%^&*]{8,16}$/)
      errors.add :password, "must include at least one special character and one digit"
    end
  end

  def send_welcome_email
    UserMailer.welcome_message(self).deliver
  end
end
