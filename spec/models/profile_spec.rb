require 'spec_helper'

describe Profile do

   describe "Profiles table should have following fields present in DB" do
    it { should have_db_column(:sys_profile_id).of_type(:string) }
    it { should have_db_column(:profile_id).of_type(:string) }
    it { should have_db_column(:profile_name).of_type(:string) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end
  describe "Profile should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :profile_name }
  end

  it "Profile should be able to have a cao" do
    t = Profile.reflect_on_association(:cao)
    t.macro.should == :has_one
  end
end
