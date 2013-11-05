class CLevelDea < ActiveRecord::Base

  establish_connection :supernpi

  self.table_name = "c_level_dea"

  attr_accessible :deanumber, :businessactivitycode, :ds1, :ds2, :ds3, :ds4, :ds5, :ds6, :ds7, :ds8,
                  :expdate, :name, :addtlco, :addr1, :addr2, :city, :state,
                  :zipcode, :subcode, :pymt, :lname, :fname, :restname

end
