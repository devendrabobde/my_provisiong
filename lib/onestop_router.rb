#
# This class contains a different methods to communicate with the OneStop Router
#
module OnestopRouter

  #
  # This method is responsible for uploading the providers data into the Onestop Router DB
  #
  def self.batch_upload(providers, application)
    body = { :users => {"" => providers } }
    url = batch_upload_url
    if application.app_name.eql?("EPCS-IDP")
      header = CONSTANT["ONESTOP_ROUTER"]["OIS"]["EPCS_IDP"]
    elsif application.app_name.eql?("Backline")
      header = CONSTANT["ONESTOP_ROUTER"]["OIS"]["Backline"]
    end
    begin
      response = RestClient.post url, body, header
      return JSON.parse(response)
    rescue => e
      return {:error => e.message }
    end
  end

  #
  # This method is responsible to obtain a list of OIS that have a record of provider
  #
  def self.request_idp(params)
    payload = request_idp_payload(params)
    headers = request_idp_header
    begin
      response = RestClient::Request.execute(:method => :get, :url => request_idp_url , :payload => payload, :headers => headers )
      return JSON.parse(response)
    rescue => e
      return
    end
  end

  def self.request_idp_payload(params)
    { :npi => params[:npi], :first_name => params[:first_name], :last_name => params[:last_name] }
  end

  def self.verify_identity(params)
    url = verify_identity_url
    payload = verify_identity_payload(params)
    headers = verify_identity_header
    begin
      response = RestClient::Request.execute(:method => :get, :url => url , :payload => payload, :headers => headers )
      return JSON.parse(response)
    rescue => e
      return
    end
  end

  def self.verify_identity_payload(params)
    { :npi => params[:npi], :first_name => params[:first_name], :last_name => params[:last_name] }
  end

  def self.save_provider(params)
    url = save_provider_url
    body = save_provider_body(params)
    headers = save_provider_header
    begin
      response = RestClient.post url,body,headers
      return JSON.parse(response)
    rescue => e
      return
    end
  end

  def self.save_provider_body(params)
    { npi: params[:npi], first_name: params[:first_name], last_name: params[:last_name] }
  end

  def self.save_provider_url
    server_url + "/" + CONSTANT["ONESTOP_ROUTER"]["API"]["SAVE_PROVIDER"]["URL"]
  end

  def self.save_provider_header
    CONSTANT["ONESTOP_ROUTER"]["OIS"]["EPCS_IDP"]
  end

  private

  def self.batch_upload_url
    server_url + "/" + CONSTANT["ONESTOP_ROUTER"]["BATCH_UPLOAD_API_URL"]
  end

  def self.batch_upload_header
    CONSTANT["ONESTOP_ROUTER"]["OIS"]["EPCS_IDP"]
  end

  def self.request_idp_url
    server_url + "/" + CONSTANT["ONESTOP_ROUTER"]["REQUEST_IDP"]["API_URL"]
  end

  def self.request_idp_header
    CONSTANT["ONESTOP_ROUTER"]["REQUEST_IDP"]["CLIENT_APPLICATION"]
  end

  def self.verify_identity_url
    server_url + "/" + CONSTANT["ONESTOP_ROUTER"]["VERIFY_IDENTITY"]["API_URL"]
  end

  def self.verify_identity_header
    CONSTANT["ONESTOP_ROUTER"]["VERIFY_IDENTITY"]["CLIENT_APPLICATION"]
  end

  def self.server_url
    CONSTANT["ONESTOP_ROUTER"]["SERVER_URL"]
  end

end
