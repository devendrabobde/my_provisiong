Feature: COA Audits Upload History
	A COA Should be able to audit the providers that he has uploaded with the history of uploads.

Background:
  Given a valid COA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message

@selenium
@no-database-cleaner
Scenario: COA Audits Upload History
	Given I go to application page
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I click on Back button for uploading same providers file again
    And I should be able to view any previously uploaded csv and its providers
    And I should be able to download any previously uploaded csv and its providers

@selenium
@no-database-cleaner
Scenario: COA upload a csv file which returns different error codes/messages and validate these codes/messages
    Given I go to application page
    Given I select an application
    When I select a csv file of providers which returns different error codes and messages
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should see uploaded csv file status with different error codes and messages