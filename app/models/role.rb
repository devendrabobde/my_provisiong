class Role < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :name

  alias_attribute :sys_role_id, :id

  #
  # Associations
  #
  has_many :caos, foreign_key: :fk_role_id

end
