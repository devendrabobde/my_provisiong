class Cao < ActiveRecord::Base

  include Extensions::UUID

  devise :database_authenticatable, :recoverable, :validatable,:timeoutable,:registerable,
         :rememberable, :trackable, :authentication_keys => [:username]

  attr_accessible :username, :first_name, :last_name, :user_id, :is_active,
                  :email, :password, :password_confirmation, :remember_me, :fk_organization_id,
                  :fk_profile_id, :fk_role_id, :deleted_reason, :deleted_at

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

  #
  # Association
  #
  has_many :audit_trails, foreign_key: :fk_cao_id
  belongs_to :profile, foreign_key: :fk_profile_id
  belongs_to :organization, foreign_key: :fk_organization_id
  belongs_to :role, foreign_key: :fk_role_id
  has_many :provider_error_logs, foreign_key: :fk_cao_id
  has_many :provider_app_details, foreign_key: :fk_cao_id

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
end
