class OldPassword < ActiveRecord::Base

  include Extensions::UUID
  
  attr_accessible :encrypted_password, :password_salt, :password_archivable_type, :password_archivable_id

  belongs_to :password_archivable, :polymorphic => true

end