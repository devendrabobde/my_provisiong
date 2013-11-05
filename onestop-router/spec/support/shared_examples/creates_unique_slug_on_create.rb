shared_examples_for "creates unique slug on create" do
  subject { create(factory, slugged_attribute => 'Rambo Connection') }

  it "creates a unique slug based on the ois name" do
    subject.save!
    subject.slug.should == 'rambo-connection'

    new_record = create(factory, slugged_attribute => 'Rambo Connection')
    new_record.slug.should == 'rambo-connection--2'
  end
end
