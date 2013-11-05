shared_examples_for "assigns default password" do
  let(:password) { Password.new }

  it { should have_db_column(password_attribute).of_type(:string).with_options(:limit => 80) }
  it { should ensure_length_of(password_attribute).is_at_least(50).is_at_most(80) }

  it "sets a password if the password is blank" do
    subject[password_attribute] = ''
    subject.should be_valid

    subject[password_attribute].should_not == ''
  end

  it "allows the password to be specified" do
    subject[password_attribute] = password
    subject.save!

    subject[password_attribute].should == password
  end

  it "creates a random password" do
    subject[password_attribute] = nil
    subject.save!

    subject.reload
    subject[password_attribute].should be_present
    subject[password_attribute].length.should be_between(50, 80)
  end
end
