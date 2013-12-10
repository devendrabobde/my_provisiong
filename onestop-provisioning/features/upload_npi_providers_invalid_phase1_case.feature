Feature: COA upload NPI providers and phase 1 validations are not satisfied
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
  Scenario: COA logs in
    And I should see correct screen title

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
    When I select CSV File of Invalid providers
    And I clicks upload button
    And I should be able to see invalid file upload message
    And No data should be uploaded in the provisioning db
    And No Audit data should be added in the Provisioning db