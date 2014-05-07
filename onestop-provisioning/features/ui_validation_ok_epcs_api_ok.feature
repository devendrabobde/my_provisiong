Feature: EPCS UI validation ok, EPCS API ok test case - COA upload providers and EPCS application responds according.
  In order to upload providers in the onestop provisioning
  As a COA
  I want to be able to upload a CSV file with the providers' data

Background:
  Given a valid COA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message
  
  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a CSV file which is containing one single provider who has all required fields
    Given I select an application
    When I select a csv file which is containing single provider who has all required fields present including VendorLabel, VendorNodeLabel, Date, Npi, Firstname, Lastname, Gender, Dateofbirth, DeaNumber, DeaState, DeaExpirationDate, PrimaryAddressLine1, PrimaryCity, PrimaryState, PrimaryZipcode, Email, TokenSerialNumber
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each uploaded providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a CSV file which is containing one single provider record including special characters, such as space, hyphen, quote
    Given I select an application
    When I select a csv file which is containing one single provider record including special characters, such as space, hyphen, quote
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each uploaded providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a CSV file which is containing one single provider who has all required fields as well as including all optional fields
    Given I select an application
    When I select a csv file which is containing single provider who has all required fields as well as including all optional fields
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each uploaded providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a CSV file which is containing one single batch of multiple providers, all pass WsBatchIdp
    Given I select an application
    When I select a csv file which is containing one single batch of multiple providers all pass WsBatchIdp
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each uploaded providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and uploading more than one batch of providers from the same spreadsheet, all pass WsBatchIdp
    Given I select an application
    When I select a csv file which is containing one batch of providers from the same spreadsheet all pass WsBatchIdp
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each uploaded providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a CSV file which is containing one single provider with one single DEA
    Given I select an application
    When I select a csv file which is containing provider with one single DEA
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each uploaded providers


  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a CSV file which is containing one single provider with multiple DEAs
    Given I select an application
    When I select a csv file which is containing provider with multiple DEAs
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each uploaded providers