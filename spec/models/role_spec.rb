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

  describe "#find_or_create_by_name" do
    it "should return role of user if the user has already some role assigned" do
      role = FactoryGirl.create(:role)
      assert role.find_or_create_by_name(role.name).should be_true
    end
    it "should create new role if user has not assigned any role" do
      role = FactoryGirl.create(:role)
      assert role.find_or_create_by_name("Organiser").should be_true
    end
  end

end
