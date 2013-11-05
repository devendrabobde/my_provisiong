module EpcsXmlRequestBuilder
    require 'builder'

    def self.org_setup_xml( org )

        xml = Builder::XmlMarkup.new( :indent => 2 )

        xml.tag!('EpcsRequest', { \
            "xmlns" => "urn:drfirst.com:epcsapi:v1_0", \
            "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", \
            "xsi:schemaLocation" => "urn:drfirst.com:epcsapi:v1_0"}) \
        do |a|

            a << (epcs_request_header org[:organization_id])
            a.EpcsRequestBody do |b|
                b.WsSetUpOrganizationStatusRequest do |r|
                    r.VendorLabel CONSTANT['EPCS']['VENDOR_LABEL']
                    r.VendorNodeLabel CONSTANT['EPCS']['VENDOR_NODE_LABEL']
                    r.OrganizationName org[:name]
                    r.Addressline1 org[:address1]
                    r.Addressline2 org[:address2]
                    r.City org[:city]
                    r.State org[:state_code]
                    r.Zipcode org[:postal_code]
                end
            end
        end
    end

    private

    def self.epcs_request_header( org_id )
        header = Builder::XmlMarkup.new( :indent => 2 )
        header.EpcsRequestHeader do |h|
            h.VendorName CONSTANT['EPCS']['VENDOR_NAME']
            h.VendorLabel CONSTANT['EPCS']['VENDOR_LABEL']
            h.VendorNodeName CONSTANT['EPCS']['VENDOR_NODE_NAME']
            h.VendorNodeLabel CONSTANT['EPCS']['VENDOR_NODE_LABEL']
            h.AppVersion do |app|
                app.AppName CONSTANT['EPCS']['APP_NAME']
                app.ApplicationVersion CONSTANT['EPCS']['APP_VERSION']
            end
            h.SourceOrganizationId org_id
            h.Date '2012-05-14T04:00:00Z'
        end
    end

end
