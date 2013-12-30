Feature: COA upload multiple records of the same provider in csv i.e entire record is duplicated (all fields are an exact match). For EPCS provisoing system is simply passing unique record for each duplicate record.
  In order to upload NPI providers in the onestop provisioning
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
  Scenario: COA selects an EPCS application and upload a CSV file which is containing multiple records of the same provider i.e entire record is duplicate (all fields are an exact match).
    Given I select an application
    When I select a csv file which is containing multiple records of the same provider
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see acknowledgement messages