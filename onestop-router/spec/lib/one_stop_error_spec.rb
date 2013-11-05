require 'spec_helper'

describe OneStopError do
  context "instance methods" do
    subject { OneStopError.new }

    shared_examples_for "overridable error parameter in instance" do
      # We use an anonymous subclass here because we're
      # changing values that will be tested in other methods.
      #
      # Using the subclass allows us to test the functionality
      # without worrying about breaking other tests.
      subject { Class.new(OneStopError).new }

      it "can be initialized to a different value" do
        options = {}
        options[parameter_name] = 'test'

        error = OneStopError.new(options)
        error.send(parameter_name).should == 'test'
      end

      it "can be changed from the writer" do
        subject.send("#{parameter_name}=", 'test')
        subject.send(parameter_name).should == 'test'
      end
    end

    describe '#category' do
      it "is 'system' by default" do
        subject.category.should == 'system'
      end

      it_behaves_like "overridable error parameter in instance" do
        let(:parameter_name) { :category }
      end
    end

    describe '#code' do
      it "is 'unknown-error' by default" do
        subject.code.should == 'unknown-error'
      end

      it_behaves_like "overridable error parameter in instance" do
        let(:parameter_name) { :code }
      end
    end

    describe '#message' do
      it "is 'Unidentified OneStop Error' by default" do
        subject.message.should == 'Unidentified OneStop Error'
      end

      it_behaves_like "overridable error parameter in instance" do
        let(:parameter_name) { :message }
      end
    end

    describe '#status' do
      it "is :internal_server_error by default" do
        subject.status.should == :internal_server_error
      end

      it_behaves_like "overridable error parameter in instance" do
        let(:parameter_name) { :status}
      end
    end

    describe "#as_json" do
      it "returns the json for the verify identity response" do
        subject.as_json.should == {
          :code    => subject.code,
          :message => subject.message
        }
      end
    end
  end

  context "class methods" do
    subject { OneStopError }

    shared_examples_for "overridable error parameter" do
      # We use an anonymous subclass here because we're
      # changing values that will be tested in other methods.
      #
      # Using the subclass allows us to test the functionality
      # without worrying about breaking other tests.
      subject { Class.new(OneStopError) }

      it "assigns the param that will be returned from instances" do
        subject.send(parameter_name, 'my param')

        subject.new.send(parameter_name).should == 'my param'
      end
    end

    describe '.category' do
      it_behaves_like "overridable error parameter" do
        let(:parameter_name) { :category }
      end
    end

    describe '.code' do
      it_behaves_like "overridable error parameter" do
        let(:parameter_name) { :code }
      end
    end

    describe '.message' do
      it_behaves_like "overridable error parameter" do
        let(:parameter_name) { :message }
      end
    end

    describe '.status' do
      it_behaves_like "overridable error parameter" do
        let(:parameter_name) { :status }
      end
    end
  end

end
