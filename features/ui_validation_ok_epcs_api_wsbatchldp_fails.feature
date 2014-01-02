Feature: EPCS UI validation ok, EPCS API WsBatchIdp fails test case - COA upload providers and EPCS application responds according.
  In order to upload providers in the onestop provisioning
  As a COA
  I want to be able to upload a CSV file with the providers' data

Background:
  Given valid COA credentials 
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message
  
  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a CSV file which contains single batch of multiple providers
    Given I select an application
    When I select a csv file which contains single batch of multiple providers for failing wsbatchldp
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see failure message for failed WsBatchIdp

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and uploads more than one batch of providers from the same spreadsheet, all fail WsBatchIdp
    Given I select an application
    When I select a csv file which contains single batch of multiple providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see failure message for failed WsBatchIdp