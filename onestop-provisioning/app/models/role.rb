class Role < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :name

  alias_attribute :sys_role_id, :id

  #
  # Associations
  #
  has_many :caos, foreign_key: :fk_role_id

  #
  # Find the role or create it
  #
  def find_or_create_by_name(name)
  	role = Role.find_by_name(name)
  	unless role
  		role = Role.create(:name => name)
  	end
  	role
  end

end
