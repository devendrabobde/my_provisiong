require 'spec_helper'

describe Role do

  describe "Roles table should have following fields present in DB" do
    it { should have_db_column(:sys_role_id).of_type(:string) }
    it { should have_db_column(:role_id).of_type(:string) }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "Role should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :name }
  end

  it "Role should be able to have multiple caos" do
    t = Role.reflect_on_association(:caos)
    t.macro.should == :has_many
  end

end
