require 'spec_helper'

describe PerformanceLog do
  it { should have_db_column(:client_id).of_type(:string).with_options(:length => 36) }
  it { should have_db_column(:request_ip).of_type(:string).with_options(:length => 20) }
  it { should have_db_column(:request_content).of_type(:string) }
  it { should have_db_column(:request_params).of_type(:text) }
  it { should have_db_column(:request_size).of_type(:integer) }
  it { should have_db_column(:controller_name).of_type(:string) }
  it { should have_db_column(:api_name).of_type(:string) }
  it { should have_db_column(:server_name).of_type(:string).with_options(:limit => 50) }
  it { should have_db_column(:server_version).of_type(:string).with_options(:limit => 50) }
  it { should have_db_column(:client_platform).of_type(:string).with_options(:limit => 50) }
  it { should have_db_column(:client_version).of_type(:string).with_options(:limit => 50) }
  it { should have_db_column(:status).of_type(:string) }
  it { should have_db_column(:error_type).of_type(:string) }
  it { should have_db_column(:error_message).of_type(:string).with_options(:limit => 2000) }
  it_should_behave_like "DrFirst database object"

  it_behaves_like "records timestamps" do
    subject { PerformanceLog.new }
  end

  it { should serialize(:request_params) }
end
