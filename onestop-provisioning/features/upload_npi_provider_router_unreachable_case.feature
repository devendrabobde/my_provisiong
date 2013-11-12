Feature: COA upload NPI providers and router is not reachable
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
Scenario: COA selects to start new upload
  Given I go to application page
  And I click on file upload button
  Then I should see message Please select application and a CSV file to initiate the provisioning process


@selenium
@no-database-cleaner
Scenario: COA selects an application and upload a CSV file of 4 providers
   Given I select an application
   And Health status should say application is unreachable
   And Upload Button Should be disabled
   And message should be displayed to inform COA status
   And No data should be uploaded in the provisioning db

