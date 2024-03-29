Feature: COA upload providers and superNPI application is unavailable after upload begin.In this case provisioing system should be showing connection error message along with error code on UI (provider detail page) corresponding to each provider.
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
  Scenario: COA selects an application and upload a CSV file of 4 providers
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see supernpi acknowledgement or error messages