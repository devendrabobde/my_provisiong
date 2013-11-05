module EpcsIdpOis
  include EpcsIntegration

  def self.batch_upload_dest(providers, cao)
    # 1. setup COA Orgnaization
    # response  = setup_coa_organization(cao)
    org = cao.organization.attributes.symbolize_keys
    org_response = EpcsIntegration::epcs_confirm_org( org )
    # 2. call batch idp to insert providers into EPCS DB
    # batch_idp(providers, cao)
  end

  def self.setup_coa_organization(cao)
    # client = Savon::Client.new("http://localhost:3000/wsdl")
    request_parameter = setup_coa_organization_request(cao)
    # response = client.call(:WsSetUpOrganizationStatusRequest, xml: method_request_parameter)
    puts request_parameter
  end

  def self.setup_coa_organization_request(cao)
    cao_organization = cao.organization
    "<EpcsRequest xmlns='urn:drfirst.com:epcsapi:v1_0' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='urn:drfirst.com:epcsapi:v1_0'>
      <EpcsRequestHeader>
        <VendorLabel>#{cao_organization.vendor_label}</VendorLabel>
        <VendorNodeLabel>#{cao_organization.vendor_node_label}</VendorNodeLabel>
        <AppVersion>
          <AppName>OneStop</AppName>
          <ApplicationVersion>1.0.1</ApplicationVersion>
        </AppVersion>
        <SourceOrganizationId>#{cao_organization.id}</SourceOrganizationId>
        <Date>#{DateTime.now.to_s.split("+").first}</Date>
        <EpcsApiVersion>1.3</EpcsApiVersion>
      </EpcsRequestHeader>
      <EpcsRequestBody>
        <WsSetUpOrganizationStatusRequest>
          <VendorLabel>#{cao_organization.vendor_label}</VendorLabel>
          <VendorNodeLabel>#{cao_organization.vendor_node_label}</VendorNodeLabel>
          <OrganizationName>#{cao_organization.name}</OrganizationName>
          <Addressline1>#{cao_organization.address1}</Addressline1>
          <Addressline2>#{cao_organization.address2}</Addressline2>
          <City>#{cao_organization.city}</City>
          <State>#{cao_organization.state_code}</State>
          <Zipcode>#{cao_organization.zip_code}</Zipcode>
        </WsSetUpOrganizationStatusRequest>
      </EpcsRequestBody>
    </EpcsRequest>"
  end

  def self.batch_idp(providers, cao)
    request = batch_idp_request(providers, cao)
    puts request
  end

  def self.batch_idp_request(providers, cao)
    prescriber_idp_request_list = []
    cao_organization = cao.organization
    providers.each do |provider|
      prescriber_idp_request_list << prescriber_idp_request(provider)
    end
    providers_request_list = prescriber_idp_request_list.join("\n")
    "<EpcsRequest xmlns='urn:drfirst.com:epcsapi:v1_0' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='urn:drfirst.com:epcsapi:v1_0'>
      <EpcsRequestHeader>
        <VendorLabel>#{cao_organization.vendor_label}</VendorLabel>
        <VendorNodeLabel>#{cao_organization.vendor_node_label}</VendorNodeLabel>
        <AppVersion>
            <AppName>OneStop</AppName>
            <ApplicationVersion>1.0.1</ApplicationVersion>
        </AppVersion>
        <SourceOrganizationId>#{cao_organization.id}</SourceOrganizationId>
        <Date>#{DateTime.now.to_s.split("+").first}</Date>
        <EpcsApiVersion>1.3</EpcsApiVersion>
    </EpcsRequestHeader>
    <EpcsRequestBody>
      <WsBatchIdpRequest>
        <PrescriberIdpRequestList>
         #{providers_request_list}
        </PrescriberIdpRequestList>
      </WsBatchIdpRequest>
    </EpcsRequestBody>
    </EpcsRequest>"
  end

  def self.prescriber_idp_request(provider)
    dea_numbers = provider["provider_dea_record"].first
    "<PrescriberIdpRequest>
      <Npi>#{provider["npi"]}</Npi>
      <Firstname>#{provider["first_name"]}</Firstname>
      <Lastname>#{provider["last_name"]}</Lastname>
      <Middlename> </Middlename>
      <Prefix>Dr.</Prefix>
      <Gender>M</Gender>
      <Dateofbirth>19570126</Dateofbirth>
      <DeaNumber>#{dea_numbers["provider_dea"]}</DeaNumber>
      <PrimaryAddressline1>#{provider["address1"]}</PrimaryAddressline1>
      <PrimaryAddressline2>#{provider["address2"]}</PrimaryAddressline2>
      <PrimaryCity>#{provider["city"]}</PrimaryCity>
      <PrimaryState>#{provider["state"]}</PrimaryState>
      <PrimaryZipcode>#{provider["zip"]}</PrimaryZipcode>
      <SocialSecurityNumber>890629517</SocialSecurityNumber>
      <Email>#{provider["email"]}</Email>
      <TokenMailingAddressline1>3300 adams ct</TokenMailingAddressline1>
      <TokenMailingAddressline2> </TokenMailingAddressline2>
      <TokenMailingCity>irving</TokenMailingCity>
      <TokenMailingState>MD</TokenMailingState>
      <TokenMailingZipcode>20850</TokenMailingZipcode>
    </PrescriberIdpRequest>"
  end

  def self.generateKey(data)
    return Digest::SHA1.hexdigest ("#{serialize(data)}")
  end

end
