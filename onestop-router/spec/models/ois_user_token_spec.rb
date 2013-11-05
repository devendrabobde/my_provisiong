require 'spec_helper'

describe OisUserToken do
  it { should have_db_column(:user_id).of_type(:string).with_options(:limit => 36, :null => false) }
  it { should have_db_column(:ois_id).of_type(:string).with_options(:limit => 36, :null => false) }
  it { should have_db_column(:token).of_type(:string) }
  it { should have_db_column(:verified_timestamp).of_type(:timestamp) }
  it_should_behave_like "DrFirst database object"

  it_behaves_like "records timestamps" do
    subject { build(:ois_user_token) }
  end

  it { should belong_to(:ois) }
  it { should belong_to(:user) }

  it { should be_audited }

  it { should delegate(:idp_level).to(:ois) }
  it { should delegate(:first_name).to(:user) }
  it { should delegate(:last_name).to(:user) }
  it { should delegate(:npi).to(:user) }

  it "validates format of token only on update" do
    ois_user_token = build(:ois_user_token, token: '')
    ois_user_token.should be_valid
    ois_user_token.save!

    ois_user_token.reload
    ois_user_token.token = ''
    ois_user_token.should_not be_valid
  end

  context "callbacks" do
    subject { build(:ois_user_token) }
    describe ".before_create" do
      it "generates a random unique token" do
        subject.token.should be_blank
        subject.save!

        subject.reload
        subject.token.should_not be_blank
      end
    end
  end

  context "class methods" do
    let(:ois_user_token)          { create(:ois_user_token) }
    let!(:another_ois_user_token) { create(:ois_user_token) }
    let(:expired_ois_user_token)  { create(:ois_user_token, createddate: 1.year.ago) }
    let(:verified_ois_user_token) { create(:ois_user_token, verified_timestamp: Time.now) }
    let(:valid_token)       { ois_user_token.token }
    subject                 { OisUserToken }

    describe ".verify_token!" do
      it "finds and validates an id token matching the given token" do
        ois_user_token.verified_timestamp.should_not be

        found_ois_user_token = subject.verify_token!(valid_token)
        found_ois_user_token.should == ois_user_token
        found_ois_user_token.verified_timestamp.should be
      end

      it "raises an OisUserToken::InvalidRequest if the token is not provided" do
        expect {subject.verify_token!()}.to raise_error(OisUserToken::InvalidRequest)
        expect {subject.verify_token!('')}.to raise_error(OisUserToken::InvalidRequest)
      end

      it "raises an OisUserToken::NotFound if an ois_user_token doesn't exist with the given token" do
        expect {subject.verify_token!('invalid-token')}.to raise_error(OisUserToken::NotFound)
      end

      it "raises an OisUserToken::Expired if the found ois_user_token is expired" do
        expired_ois_user_token.createddate = 1.year.ago
        expired_ois_user_token.save!
        expect {subject.verify_token!(expired_ois_user_token.token)}.to raise_error(OisUserToken::Expired)
      end

      it "raises an OisUserToken::AlreadyVerified if the found ois_user_token has already been verified" do
        expect {subject.verify_token!(verified_ois_user_token.token)}.to raise_error(OisUserToken::AlreadyVerified)
      end
    end
  end

  context "instance methods" do
    subject { create(:ois_user_token) }

    describe "#verified?" do
      it "returns true if the ID Token has already been verified" do
        OisUserToken.verify_token!(subject.token)

        subject.reload
        subject.verified?.should be_true
      end

      it "returns false if the ID Token has not yet been verified" do
        subject.verified_timestamp.should_not be
        subject.verified?.should be_false
      end
    end

    describe "#verified?" do
      it "returns true if the ID Token has already been verified" do
        OisUserToken.verify_token!(subject.token)

        subject.reload
        subject.verified?.should be_true
      end

      it "returns false if the ID Token has not yet been verified" do
        subject.verified_timestamp.should_not be
        subject.verified?.should be_false
      end
    end

    # These test depend on the 'tokens_expire_in' setting from config/server.yml
    describe "#expired?" do
      before do
        subject.stub(:server_configuration).and_return({:tokens_expire_in => 1.month})
      end

      it "returns true if the ID Token has expired" do
        subject.createddate = 1.year.ago
        subject.expired?.should be_true
      end

      it "returns false if the ID Token has not expired" do
        subject.createddate = 1.day.ago
        subject.expired?.should be_false
      end
    end
  end
end
