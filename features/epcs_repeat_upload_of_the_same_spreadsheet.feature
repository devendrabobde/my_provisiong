Feature: EPCS repeat upload of the same spreadsheet test case - COA upload providers and EPCS application responds according.
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
  Scenario: COA selects an EPCS application and upload all valid providers and then repeat upload a second time
    Given I select an application
    When I select a csv file which is containing all valid providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each valid providers
    When I click on Back button for uploading same providers file again
    Then I should be able to see Upload home page
    Given I select an application
    When I select a csv file which contains all valid providers and then repeat upload a second time
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see success message corresponding to each valid providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload all invalid providers, then upload again with fixes
    Given I select an application
    When I select a csv file which is containing all invalid providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see error message corresponding to each invalid providers
    When I click on Back button for uploading same providers file again
    Then I should be able to see Upload home page
    Given I select an application
    When I select a csv file which contains all valid providers after fixing invalid providers and upload a second time
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each valid providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a mixture of valid and invalid providers, then upload again with all fixes
    Given I select an application
    When I select a csv file which is containing mixture of valid and invalid providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see error message corresponding to each invalid providers
    When I click on Back button for uploading same providers file again
    Then I should be able to see Upload home page
    Given I select an application
    When I select a csv file which contains all valid providers after fixing invalid providers records
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success message corresponding to each valid providers

  @selenium
  @no-database-cleaner
  Scenario: COA selects an EPCS application and upload a mixture of valid and invalid provdiers, then upload again with partial fixes (some of the providers fail twice)
    Given I select an application
    When I select a csv file which is containing mixture of valid and invalid providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see error message corresponding to each invalid providers
    When I click on Back button for uploading same providers file again
    Then I should be able to see Upload home page
    Given I select an application
    When I select a csv file after partial fixes and upload again
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see success or error message corresponding to each valid and invalid providers