shared_examples_for "syncs disabled date" do
  it { should have_db_column(:disabled).of_type(:boolean).with_options(:default => false) }
  it { should have_db_column(:disabled_date).of_type(:timestamp) }
  it { should be_kind_of(Mixins::OneStop::DisabledDate) }

  it "sets disabled_date to now if becoming disabled" do
    Timecop.freeze(Time.now) do
      subject.disabled = true
      subject.save!

      subject.disabled_date.should == Time.now
    end
  end

  it "sets disabled_date to nil if becoming enabled" do
    subject.disabled = true
    subject.save!

    subject.disabled = false
    subject.save!
    subject.disabled_date.should be_nil
  end

  it "doesn't change disabled date if disabled isn't changed" do
    subject.save!

    subject.disabled_date.should be_nil
  end
end
