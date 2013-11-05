class NpiDeaXref < ActiveRecord::Base

  establish_connection :supernpi

  self.table_name = "npi_dea_xref"

  attr_accessible  :npi_code, :deanumber

end
