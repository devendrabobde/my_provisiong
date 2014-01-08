Feature: COA upload NPI providers and submit an organization to EPCS

Background:
  Given a valid COA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message

  @selenium
  @no-database-cleaner
  Scenario: COA selects a csv file with single provider passing WsBatchIdp and with organization already registered with epcs, COA uploads a file with single provider passing WsBatchIdp
    Given I select an application
    When I select a csv file with single provider passing WsBatchIdp
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see simple acknowledgement messages
    When I redirect back to home page
    Given I select an application
    When I select a csv file with single provider passing WsBatchIdp and with already registered Organization
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, and click on the second csv file
    And I should be able to see simple acknowledgement messages

  @selenium
  @no-database-cleaner
  Scenario: COA selects a csv file with single provider failing WsBatchIdp
    Given I select an application
    When I select a csv file with single provider failing WsBatchIdp
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see the error message from WsBatchIdp
    When I select csv file having single provider failing WsBatchIdp and with already registered Organization
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, and click on the second csv file
    And I should be able to see the error message from WsBatchIdp