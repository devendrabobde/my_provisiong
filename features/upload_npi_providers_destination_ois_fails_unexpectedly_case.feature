Feature: COA upload NPI providers and destination OIS fails unexpectedly
  In order to upload NPI providers in the onestop provisioning
  As a COA
  I want to be able to upload a CSV file with the providers' data

Background:
  Given a valid COA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"

@selenium
@no-database-cleaner
  Scenario: COA logs in
  Then I should see success message

  
@selenium
@no-database-cleaner
Scenario: COA selects an application and uploads a CSV file of 4 providers
  Given I select an application
  When I select a csv file of 4 providers
  And I clicks upload button
  And I should be able to see correct file upload message
  And I should be able to see progress bar
  And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router