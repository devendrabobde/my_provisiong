module EpcsIntegration
    require 'digest/sha1'
    require "net/http"
    require "uri"
    include EpcsXmlRequestBuilder

    def self.epcs_confirm_org( org )

        xml_request = EpcsXmlRequestBuilder::org_setup_xml( org )
        url = CONSTANT['EPCS']['EPCS_URL'] + "/" + CONSTANT['EPCS']['SETUP_ORG_WS']
        xml_response = call_epcs( xml_request, url )

        return false unless (xml_response != nil)

        begin
            xml_hash = Hash.from_xml( xml_response )
            result = (org_is_already_setup? xml_hash) || (org_setup_success? xml_hash)
        rescue => e
            Rails.logger.error e
            false
        end
    end

private

    def self.call_epcs xml, url
        begin

            request_params = create_request_params( xml )
            rest_client_response = RestClient.post url, request_params

            xml_response = rest_client_response.body

        rescue => e
            Rails.logger.error e
        ensure

            Rails.logger.info \
                "EPCS communication summary:\n\nURL:#{url}\n\nSent to EPCS:\
                \n\n#{xml}\n\nReceived from EPCS:\n\n#{xml_response}"
        end
        xml_response
    end

    def self.create_request_params( xml )

        issue_timestamp = CONSTANT['EPCS']['ISSUE_TIMESTAMP']
        shared_secret = CONSTANT['EPCS']['SHARED_SECRET']
        vendor_key_version = CONSTANT['EPCS']['VENDOR_KEY_VERSION']

        hash_value = Digest::SHA1.base64digest(xml + issue_timestamp + shared_secret)

        request_params = { \
            "dataIn" => xml, \
            "hashValue" =>  hash_value, \
            "vendorKeyVersion" => vendor_key_version, \
            "issueTimeStamp" => issue_timestamp, \
            "hashAlgorithm" => 'SHA1' }

        Rails.logger.info request_params.inspect

        request_params
    end

    def self.org_setup_success? ( xml_hash )
        begin
            # SUCCESS means that organization has been successfully set up
            value = "SUCCESS" == xml_hash["EpcsResponse"] \
            ["EpcsResponseBody"] \
            ["WsSetUpOrganizationStatusResponse"] \
            ["OrganizationResponse"] \
            ["Status"]
        rescue NoMethodError
            value = false
        end
    end

    def self.org_is_already_setup? ( xml_hash )
        begin

            # code 302 means that organization has already been set up
            value = "302" == xml_hash["EpcsResponse"] \
            ["EpcsResponseBody"] \
            ["WsSetUpOrganizationStatusResponse"] \
            ["OrganizationResponse"] \
            ["Error"] \
            ["ErrorCode"]
        rescue NoMethodError
            value = false
        end
    end
end
