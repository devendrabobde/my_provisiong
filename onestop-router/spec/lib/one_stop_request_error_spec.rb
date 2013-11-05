require 'spec_helper'

describe OneStopRequestError do
  its(:category) { should == 'request' }
  its(:code)     { should == 'unknown-error' }
  its(:message)  { should == 'Unknown Request Error' }
  its(:status)   { should == :ok }

  context "class methods" do
    describe '.error_type' do
      let(:error_class) { OneStopRequestError.error_type(code: 'error-code', message: 'error message', status: :internal_server_error) }
      subject { error_class.new }

      it { should be_kind_of(StandardError) }
      it { should be_kind_of(OneStopRequestError) }

      its(:category) { should == 'request' }
      its(:code)     { should == 'error-code' }
      its(:message)  { should == 'error message' }
      its(:status)   { should == :internal_server_error }

      it "won't change the code and message for OneStopRequestError" do
        # This test ensures that the subclass doesn't effect the parent
        subject
        one_stop_request_error = OneStopRequestError.new

        one_stop_request_error.code.should == 'unknown-error'
        one_stop_request_error.message.should == 'Unknown Request Error'
        one_stop_request_error.status.should == :ok
      end
    end
  end
end
