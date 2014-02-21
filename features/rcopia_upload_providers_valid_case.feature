Feature: COA upload NPI providers to Rcopia and completes successfully
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
    And I should see application selection list
    And I should see file selection button
    And I should see application csv template download button
    And I should see correct section names

  @selenium
  @no-database-cleaner
  Scenario: COA selects to start new upload
    Given I go to application page
    And I click on file upload button
    Then I should see message Please select application and a CSV file to initiate the provisioning process

  @selenium
  @no-database-cleaner
  Scenario: COA selects an application and upload a CSV file
    Given I select rcopia application
    When I select a csv file of valid rcopia providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to add audit data in Provisioning DB
    And I should be able to see simple acknowledgement messages