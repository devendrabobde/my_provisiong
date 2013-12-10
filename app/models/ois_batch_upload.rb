class OisBatchUpload < ActiveRecord::Base

  include Extensions::UUID

  attr_accessible :ois_name, :ois_id, :ois_password

  alias_attribute :sys_ois_batch_upload_id, :id

end
