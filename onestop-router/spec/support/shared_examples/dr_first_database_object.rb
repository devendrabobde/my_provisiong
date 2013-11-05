shared_examples_for "DrFirst database object" do
  it { should have_db_column(:creatorid).of_type(:string).with_options(:limit => 36) }
  it { should have_db_column(:lastupdateid).of_type(:string).with_options(:limit => 36) }
  it { should have_db_column(:createddate).of_type(:timestamp) }
  it { should have_db_column(:lastupdatedate).of_type(:timestamp) }
  it { should have_db_column(:createddate_as_number).of_type(:integer) }
  it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
end
