module DrFirstMigrationHelpers
  def create_onestop_table(table_name, &block)
    create_table table_name, &block
    add_onestop_columns table_name
  end

  def add_onestop_columns(table)
    add_column table, :creatorid, :string, :limit => 36
    add_column table, :lastupdateid, :string, :limit => 36

    add_column table, :createddate, :timestamp
    add_column table, :lastupdatedate, :timestamp
    add_column table, :createddate_as_number, :virtual, :as => "TO_NUMBER(TO_CHAR(CREATEDDATE, 'yyyymmddhh24miss'))", :type => :integer
    add_column table, :lastupdatedate_as_number, :virtual, :as => "TO_NUMBER(TO_CHAR(LASTUPDATEDATE, 'yyyymmddhh24miss'))", :type => :integer
  end
end
