Feature: COA upload NPI providers without required fields to Rcopia and completes successfully
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
  Scenario: COA selects an application and upload a CSV file with provider without required field
    Given I go to application page
    Given I select rcopia application
    When I select a csv file of providers without required fields for rcopia
    And I clicks upload button
    And I should be able to see error message for Rcopia required fields
    And the file should not be uploaded