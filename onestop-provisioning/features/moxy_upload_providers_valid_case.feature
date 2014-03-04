Feature: COA upload NPI providers to Moxy and completes successfully
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
  Scenario: COA selects an application and upload a CSV file
    Given I go to application page
    Given I select moxy application
    When I select a csv file of valid moxy providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB for application
    And I should be able to add audit data in Provisioning DB
    And I should be able to see simple acknowledgement messages