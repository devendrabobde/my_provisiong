require 'spec_helper'

describe "api parameter constraints" do
  let(:valid_npi)       { '0123456789' }
  let(:valid_ois_id)    { 'this-is-a-slug' }
  let(:valid_idp_level) { '2' }

  let(:valid_user_params) { { :npi => valid_npi, :first_name => 'Nicholas', :last_name => 'Hance' } }

  let(:client_request_idp)     { { :get => api_v1_client_request_idp_index_path(request_params) } }
  let(:client_verify_identity) { { :get => api_v1_client_verify_identity_index_path(request_params) } }
  let(:client_verify_id_token) { { :get => api_v1_client_verify_id_token_path(request_params) } }
  let(:client_view_user)       { { :get => api_v1_client_view_user_index_path(request_params) } }
  let(:ois_id_tokens)          { { :post => api_v1_ois_id_tokens_path(request_params) } }
  let(:ois_users)              { { :post => api_v1_ois_users_path(request_params) } }

  def find_route(route_hash)
    method, path = route_hash.to_a.first

    routes.recognize_path(path, :method => method)
  end

  context "an api request" do
    subject { client_request_idp }

    context "invalid with invalid user_params" do
      context "is invalid with invalid npi - length" do
        let(:request_params) { valid_user_params.merge(:npi => '12345678') }

        it "raises OneStopRequestError" do
          expect { find_route subject }.to raise_error(OneStopRequestError, "The following parameters are invalid: npi")
        end
      end

      context "is invalid with invalid npi - format" do
        let(:request_params) { valid_user_params.merge(:npi => 'badnpifour') }

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: npi")
        end
      end

      context "is invalid with invalid first_name - format" do
        let(:request_params) { valid_user_params.merge(:first_name => 'abc123') }

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: first_name")
        end
      end

      context "is invalid with invalid last_name - format" do
        let(:request_params) { valid_user_params.merge(:last_name => 'abc123') }

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: last_name")
        end
      end

      context "is invalid with invalid first_name, last_name, and npi" do
        let(:request_params) { { :first_name => "r2-d2", :last_name => "3364", :npi => "Applesauce" } }

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: first_name, last_name, npi")
        end
      end
    end

    context "invalid with invalid npi" do
      context "is invalid with invalid npi - length" do
        let(:request_params) { { :npi => '0123456' } }

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: npi")
        end
      end

      context "is invalid with invalid npi - format" do
        let(:request_params) { { :npi => 'longenough' } }

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: npi")
        end
      end
    end

    context "invalid with invalid idp_level" do
      context "is invalid with invalid idp_level - format" do
        let(:request_params) { { :idp_level => "hello, this is dog" } } 

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: idp_level")
        end
      end

      context "is invalid with invalid idp_level - range" do
        let(:request_params) { { :idp_level => '0' } } 

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: idp_level")
        end
      end

      context "is invalid with invalid idp_level - range" do
        let(:request_params) { { :idp_level => '6' } } 

        it "raises OneStopRequestError" do
          expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: idp_level")
        end
      end
    end

    context "valid with user_params" do
      let(:request_params) { valid_user_params }

      it { should be_routable }
    end

    context "valid with user_params and ois_id and idp_level" do
      let(:request_params) { valid_user_params.merge(:idp_level => valid_idp_level).merge(:ois_id => valid_ois_id) }

      it { should be_routable }
    end

    context "valid with valid token" do
      let(:request_params) { { :token => Password.new } }

      it { should be_routable }
    end

    context "is invalid with invalid token" do
      let(:request_params) { { :token => "Invalid password. This is far too short." } }

      it "raises OneStopRequestError" do
        expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: token")
      end
    end

    context "is invalid with blank token" do
      let(:request_params) { { :token => "" } }

      it "raises OneStopRequestError" do
        expect { find_route(subject) }.to raise_error(OneStopRequestError, "The following parameters are invalid: token")
      end
    end
  end
end
