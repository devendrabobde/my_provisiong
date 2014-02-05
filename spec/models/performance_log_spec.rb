require 'spec_helper'

describe PerformanceLog do

  describe "PerformanceLog table should have following fields present in DB" do
    it { should have_db_column(:sys_performance_log_id).of_type(:string) }
    it { should have_db_column(:performance_log_id).of_type(:string) }
    it { should have_db_column(:controller_name).of_type(:string) }
    it { should have_db_column(:server_name).of_type(:string) }
    it { should have_db_column(:server_version).of_type(:string) }
    it { should have_db_column(:server_ip).of_type(:string) }
    it { should have_db_column(:server_instance_name).of_type(:string) }
    it { should have_db_column(:action_name).of_type(:string) }
    it { should have_db_column(:client_id).of_type(:string) }
    it { should have_db_column(:request_params).of_type(:text) }
    it { should have_db_column(:request_ip).of_type(:string) }
    it { should have_db_column(:request_content).of_type(:string) }
    it { should have_db_column(:request_time).of_type(:timestamp) }
    it { should have_db_column(:response_content).of_type(:text) }
    it { should have_db_column(:response_time).of_type(:decimal) }
    it { should have_db_column(:client_platform).of_type(:string) }
	it { should have_db_column(:client_version).of_type(:string) }
	it { should have_db_column(:error_code).of_type(:string) }
	it { should have_db_column(:error_description).of_type(:text) }
	it { should have_db_column(:db_response_time).of_type(:decimal) }
	it { should have_db_column(:total_response_time).of_type(:decimal) }
    it { should have_db_column(:deleted).of_type(:string) }
    it { should have_db_column(:creatorid).of_type(:string) }
    it { should have_db_column(:createddate).of_type(:datetime) }
    it { should have_db_column(:lastupdateid).of_type(:string) }
    it { should have_db_column(:lastupdatedate).of_type(:datetime) }
    it { should have_db_column(:createddate_as_number).of_type(:integer) }
    it { should have_db_column(:lastupdatedate_as_number).of_type(:integer) }
  end

  describe "PerformanceLog should be allowed to modify following attributes" do
    it { should allow_mass_assignment_of :controller_name }
    it { should allow_mass_assignment_of :server_name }
    it { should allow_mass_assignment_of :server_version }
    it { should allow_mass_assignment_of :server_ip }
    it { should allow_mass_assignment_of :server_instance_name }
    it { should allow_mass_assignment_of :action_name }
    it { should allow_mass_assignment_of :client_id }
    it { should allow_mass_assignment_of :request_params }
    it { should allow_mass_assignment_of :request_ip }
    it { should allow_mass_assignment_of :request_content }
    it { should allow_mass_assignment_of :request_time }
    it { should allow_mass_assignment_of :response_content }
    it { should allow_mass_assignment_of :response_time }
    it { should allow_mass_assignment_of :client_platform }
    it { should allow_mass_assignment_of :client_version }
    it { should allow_mass_assignment_of :error_code }
    it { should allow_mass_assignment_of :error_description }
    it { should allow_mass_assignment_of :db_response_time }
    it { should allow_mass_assignment_of :total_response_time }
  end
end
