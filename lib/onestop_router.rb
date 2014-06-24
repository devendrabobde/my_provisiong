#
# This class contains a different methods to communicate with the OneStop Router
#
module OnestopRouter

  #
  # This method is responsible for uploading the providers data into the Onestop Router DB
  #
  def self.batch_upload(providers, application, app_hash_router) 
    body = { :users => {"" => providers } }
    url = batch_upload_url
    header = {"OISID"=>(app_hash_router["ois_name"] rescue ""), "OISPASSWORD"=>(app_hash_router["ois_password"] rescue "")} 
    begin
      response = RestClient.post url, body, header
      return JSON.parse(response)
    rescue => e
      Rails.logger.error e
      return {:error => e.message }
    ensure
      Rails.logger.info \
        "Provisioning: Onestop-Router OIS communication summary:\n\nURL:#{url}\n\nHeader:#{header}\n\nSent to Onestop-Router:\
          \n\n#{body}\n\nReceived from Onestop-Router:\n\n#{response rescue nil}"
    end
  end

  def self.request_batchupload_responders(org)
    # body = { :organization => org }
    body = {}
    url = request_batchupload_responders_url
    header = CONSTANT["ONESTOP_ROUTER"]["OIS"]["PROVISIONING_UI"]
    begin
      response = RestClient.get url, header
      return [JSON.parse(response)].flatten
    rescue => e
      Rails.logger.error e
      return [{"errors" => [{"message" => e.message}] }]
    ensure
      Rails.logger.info \
        "Provisioning: Onestop-Router OIS request-batchupload-responders communication summary:\n\nURL:#{url}\n\nHeader:#{header}\n\nSent to Onestop-Router:\
          \n\n#{body}\n\nReceived from Onestop-Router:\n\n#{response rescue nil}"
    end
  end

  private

  def self.batch_upload_url
    server_url + "/" + CONSTANT["ONESTOP_ROUTER"]["BATCH_UPLOAD_API_URL"]
  end

  def self.server_url
    CONSTANT["ONESTOP_ROUTER"]["SERVER_URL"]
  end

  def self.request_batchupload_responders_url
    server_url + "/" + CONSTANT["ONESTOP_ROUTER"]["REQUEST_BATCHUPLOAD_RESPONDERS_URL"]
  end

end
