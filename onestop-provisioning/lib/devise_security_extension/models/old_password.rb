class OldPassword < ActiveRecord::Base
  
  include Extensions::UUID
  
  attr_accessible :encrypted_password, :password_salt

  belongs_to :password_archivable, :polymorphic => true

end