require 'spec_helper'

describe "RequestLoggings" do

  describe "a client makes a get request to 'request-idp' as a valid client" do
    before do
      request_idp_precursor
      get api_v1_client_request_idp_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request with a client id" do
      logged_request(@ois_client.id)
    end
  end

  describe "a client makes a get request to 'request-idp' with an IDP level" do
    before do
      request_idp_precursor
      get api_v1_client_request_idp_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}&min_idp_level=2", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request with a client id" do
      logged_request(@ois_client.id)
    end
  end

  describe "a client makes a get request to 'request-idp' with an OIS id" do
    before do
      request_idp_precursor
      get api_v1_client_request_idp_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}&ois_id=#{@ois_1.id}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request with a client id" do
      logged_request(@ois_client.id)
    end
  end

  describe "a client makes a get request to 'request-idp' with a non-existent NPI" do
    before do
      request_idp_precursor
      get api_v1_client_request_idp_index_path+"?npi=1231231230&first_name=#{@user.first_name}&last_name=#{@user.last_name}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

  describe "a client makes a get request to 'request-idp' with invalid user data" do
    before do
      request_idp_precursor
      get api_v1_client_request_idp_index_path+"?npi=1234567890&first_name=Carlos&last_name=Sanchez", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

  describe "a valid client makes a get request to 'verify-identity'" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request with a client id" do
      logged_request(@ois_client.id)
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with a minimum IDP level" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}&min_idp_level=2", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request with a client id" do
      logged_request(@ois_client.id)
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with an OIS id or slug" do
    context "make request with a an ois id" do
      before do
        verify_identity_precursor
        get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}&ois_id=#{@ois_1.id}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
      end
      specify "the logged request with a client id" do
        logged_request(@ois_client.id)
      end
    end
    context "make request with a slug" do
      before do
        verify_identity_precursor
        get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}&ois_id=#{@ois_2.slug}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
      end
      specify "the logged request with a client id" do
        logged_request(@ois_client.id)
      end
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with an OIS id or slug that does not exist" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}&last_name=#{@user.last_name}&ois_id=0000000000", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with an NPI that does not exist" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?npi=1231231230&first_name=#{@user.first_name}&last_name=#{@user.last_name}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with invalid user data" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}ww&last_name=#{@user.last_name}ww", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with missing npi parameter" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?first_name=#{@user.first_name}&last_name=#{@user.last_name}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with missing first_name parameter" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&last_name=#{@user.last_name}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

  describe "a valid client makes a get request to 'verify-identity' with missing last_name parameter" do
    before do
      verify_identity_precursor
      get api_v1_client_verify_identity_index_path+"?npi=#{@user.npi}&first_name=#{@user.first_name}", nil, {'HTTP_CLIENTID' => @ois_client.client_name, 'HTTP_CLIENTPASSWORD' => @ois_client.client_password}
    end
    specify "the logged request without a client id" do
      logged_request
    end
  end

end
