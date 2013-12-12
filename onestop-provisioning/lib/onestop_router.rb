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
  
  private

  def self.batch_upload_url
    server_url + "/" + CONSTANT["ONESTOP_ROUTER"]["BATCH_UPLOAD_API_URL"]
  end
  
  def self.server_url
    CONSTANT["ONESTOP_ROUTER"]["SERVER_URL"]
  end
  
end