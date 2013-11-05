require 'spec_helper'

describe Password do
  it "is between 50 and 80 characters in length" do
    subject.length.should >= 50
    subject.length.should <= 80
  end

  it { should be_kind_of(String) }
end
