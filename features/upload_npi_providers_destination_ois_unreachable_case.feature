Feature: COA upload NPI providers and destination OIS unreachable
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
Scenario: COA selects an application and upload a CSV file of 4 providers
  Given I select an application
  And Health status should say router is unreachable
  And Upload Button Should be disabled
  And Message should be displayed to inform COA status
  And No data should be uploaded in the provisioning db