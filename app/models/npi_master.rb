class NpiMaster < ActiveRecord::Base

  establish_connection :supernpi

  self.table_name = "npi_master"

  attr_accessible :npi_code, :provider_org_name, :provider_last_name, :provider_first_name,
                  :provider_middle_name

  #
  # Class Methods
  #

  def self.find_by_npi(npi_code)
    where(npi_code: npi_code).first
  end

  def self.join_result(npi_code)
    query_result = connection.execute("select npi_master.*, c_level_dea.*  from npi_dea_xref
        inner join npi_master on npi_dea_xref.npi_code = npi_master.npi_code
        inner join c_level_dea on npi_dea_xref.deanumber = c_level_dea.deanumber where npi_master.npi_code = #{npi_code}")
    provider_detail = []
    while result = query_result.fetch_hash
      provider_detail << result
    end
    query_result.close
    provider_detail
  end
end
