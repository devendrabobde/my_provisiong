class AdminUser < ActiveRecord::Base
  self.table_name = "onestop_admin_user"

  include Mixins::OneStop::DisabledDate

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  audited

  validate :provide_username_suggestions
  validates_presence_of :user_name
  validates_format_of   :user_name, with: Formats::USERNAME

  attr_accessible :user_name, :email, :password, :password_confirmation, :remember_me, :disabled

  attr_accessor :login

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["LOWER(user_name) = :value OR LOWER(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def active_for_authentication?
    super and not disabled?
  end

  def display_name
    user_name
  end

  def provide_username_suggestions
    unless username_unique?(self.user_name)
      errors.add(:user_name, "has already been taken. Try suggested usernames: #{suggested_usernames.join(', ')}")
    end
  end

  private
  def username_unique?(name)
    if persisted?
      # Check for records other than this one with the same user name.
      conditions = ["user_name = ? AND #{self.class.primary_key} != ?", user_name, id]
    else
      conditions = {:user_name => name}
    end

    !self.class.where(conditions).exists?
  end

  def suggested_usernames
    number_to_suggest = 2

    names = []
    count = 0
    while names.size < number_to_suggest
      count += 1
      name   = "#{self.user_name}#{count}"

      names << name if username_unique?(name)
    end

    names
  end
end
