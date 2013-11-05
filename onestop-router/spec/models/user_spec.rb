require 'spec_helper'

describe User do
  it { should have_db_column(:npi).of_type(:string).with_options(:limit => 25, :null => false) }
  it { should have_db_column(:first_name).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:last_name).of_type(:string).with_options(:limit => 80) }
  it { should have_db_column(:enabled).of_type(:boolean).with_options(:default => true) }
  it_should_behave_like "DrFirst database object"

  it_behaves_like "records timestamps" do
    subject { build(:user) }
  end

  it { should have_and_belong_to_many(:oises) }

  it { should validate_uniqueness_of(:npi) }
  it { should validate_format_of(:npi).with("1234567890") }
  it { should validate_format_of(:first_name).with("Nicholas") }
  it { should validate_format_of(:last_name).with("Hance") }

  it { should be_audited }

  context "class methods" do
    let(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let(:valid_request) { {:npi => user.npi, :first_name => user.first_name, :last_name => user.last_name} }
    let(:invalid_request) { valid_request.merge!(:invalid_param => 'not allowed') }
    subject { User }

    describe ".find_by_request" do
      it "finds a user for a valid request" do
        found_user = subject.find_by_request(valid_request)
        found_user.should == user
      end

      it "raises a User::NotFound if a user doesn't exist with the given npi" do
        valid_request_with_unknown_npi = valid_request.merge(:npi => 'nonexistent')
        expect {subject.find_by_request(valid_request_with_unknown_npi)}.to raise_error(User::NotFound)
      end

      it "raises a User::NameMismatch if a user doesn't exist with the given npi" do
        name_mismatch_request = valid_request.merge(:first_name => 'invalid-name')
        expect {subject.find_by_request(name_mismatch_request)}.to raise_error(User::NameMismatch)
      end

      it "raises a User::InvalidRequest if the request is missing the npi param" do
        valid_request_with_missing_npi = valid_request.delete_if {|key,value| key == :npi}
        expect {subject.find_by_request(valid_request_with_missing_npi)}.to raise_error(User::InvalidRequest)
      end

      it "raises a User::InvalidRequest if the request is missing the first_name param" do
        valid_request_with_missing_first_name = valid_request.delete_if {|key,value| key == :first_name}
        expect {subject.find_by_request(valid_request_with_missing_first_name)}.to raise_error(User::InvalidRequest)
      end

      it "raises a User::InvalidRequest if the request is missing the last_name param" do
        valid_request_with_missing_last_name = valid_request.delete_if {|key,value| key == :last_name}
        expect {subject.find_by_request(valid_request_with_missing_last_name)}.to raise_error(User::InvalidRequest)
      end
    end

    describe ".find_by_npi!" do
      it "returns a user matching the provided npi" do
        found_user = subject.find_by_npi!(valid_request[:npi])
        found_user.should == user
      end

      it "raises a User::InvalidRequest if the request is missing the npi param" do
        valid_request_with_missing_npi = valid_request.delete_if {|key,value| key == :npi}
        expect {subject.find_by_npi!}.to raise_error(User::InvalidRequest)
        expect {subject.find_by_npi!('')}.to raise_error(User::InvalidRequest)
      end

      it "raises a User::NotFound if a user doesn't exist with the given npi" do
        expect {subject.find_by_npi!('non-existent')}.to raise_error(User::NotFound)
      end
    end
  end

  context "instance methods" do
    let(:user) { create(:user) }
    let(:valid_request) { {:npi => user.npi, :first_name => user.first_name, :last_name => user.last_name} }

    describe "#matches_request?" do
      it "returns true if the first and last name of the request match the found user" do
        user.matches_request?(valid_request).should be_true
      end

      it "returns false if the first name of the request does not match the found user" do
        user.matches_request?(valid_request.merge(:first_name => 'invalid-name')).should be_false
      end

      it "returns false if the last name of the request does not match the found user" do
        user.matches_request?(valid_request.merge(:last_name => 'invalid-name')).should be_false
      end
    end
  end
end