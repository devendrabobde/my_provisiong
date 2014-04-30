class Profile < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :profile_name

  alias_attribute :sys_profile_id, :id

  #
  # Associations
  #
  has_one :cao, foreign_key: :fk_profile_id

end
