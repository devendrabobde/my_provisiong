Feature: COA upload providers and RCopia application is unavailable/unreachable (network interruption) after upload begin. In this case provisioing system should be showing connection error message along with error code on UI (provider detail page) corresponding to each provider.
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
  Scenario: COA upload providers and Rcopia application is unreachable (network interruption) after upload begin
    Given I go to application page
    Given I select rcopia application
    When I select a csv file of invalid providers for rcopia
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB for application
    And I should be able to see Rcopia acknowledgement or error messages

  @selenium
  @no-database-cleaner
  Scenario: COA selects an application and upload a CSV file of 4 providers
    Given I go to application page
    Given I select rcopia application
    When I select a csv file of invalid providers for rcopia
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB for application
    And I should be able to see onestop-router acknowledgement or error messages