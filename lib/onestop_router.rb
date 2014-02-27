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
    elsif application.app_name.eql?("Rcopia")
      header = CONSTANT["ONESTOP_ROUTER"]["OIS"]["RCOPIA"]
    elsif application.app_name.eql?("Moxy")
      header = CONSTANT["ONESTOP_ROUTER"]["OIS"]["MOXY"]
    end
    begin
      response = RestClient.post url, body, header
      return JSON.parse(response)
    rescue => e
      Rails.logger.error e
      return {:error => e.message }
    ensure
      Rails.logger.info \
        "Onestop-Provisioning: Onestop-Router OIS communication summary:\n\nURL:#{url}\n\nHeader:#{header}\n\nSent to Onestop-Router:\
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

end
