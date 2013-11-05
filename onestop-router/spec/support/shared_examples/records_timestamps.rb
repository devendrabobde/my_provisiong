shared_examples_for "records timestamps" do
  # Assumes 'subject' is the result of a `build` call.
  # ex: subject { build(:client) }
  #
  # Usage:
  # it_should_behave_like "records_timestamps" do
  #   subject { build(:client) }
  # end
  it { should be_kind_of(Mixins::OneStop::Timestamps) }

  context "callbacks" do
    describe "before_create" do
      its(:createddate) { should be_nil }

      context "when created" do
        before { subject.save! }

        its(:createddate) { should be_within(1).of(Time.now.utc) }
      end

      context "when saved" do
        let(:time_of_creation) { Time.now.utc }
        let(:time_of_save)     { Time.now.utc + 2.days }

        before do
          Timecop.freeze(time_of_creation) do
            subject.save!
          end

          Timecop.freeze(time_of_save)
          subject.save!
        end

        its(:createddate) { should be_within(1).of(time_of_creation) }
      end
    end

    describe "before_save" do
      its(:lastupdatedate) { should be_nil }

      context "when created" do
        before { subject.save! }

        its(:lastupdatedate) { should be_within(1).of(Time.now.utc) }
      end

      context "when saved" do
        let(:time_of_creation) { Time.now.utc }
        let(:time_of_save)     { Time.now.utc + 2.days }

        before do
          Timecop.freeze(time_of_creation) do
            subject.save!
          end

          Timecop.freeze(time_of_save)
          subject.save!
        end

        its(:lastupdatedate) { should be_within(1).of(time_of_save) }
      end
    end

    after { Timecop.return }
  end
end
