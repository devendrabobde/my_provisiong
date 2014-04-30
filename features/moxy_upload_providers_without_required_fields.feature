Feature: COA upload providers without required fields to Moxy
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
  Scenario: COA selects an application and upload a CSV file with provider without required field
    Given I go to application page
    Given I select moxy application
    When I select a csv file of providers with missing required field for moxy
    And I clicks upload button
    And I should be able to see error message for required fields
    And the file should not be uploaded

  @selenium
  @no-database-cleaner
  Scenario: COA selects an application and upload a CSV file with providers missing multiple required fields
    Given I go to application page
    Given I select moxy application
    When I select a csv file of providers with missing multiple required fields for moxy
    And I clicks upload button
    And I should be able to see error message for required fields
    And the file should not be uploaded
