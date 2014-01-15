Feature: COA upload NPI providers which are already registered

Background:
  Given a valid COA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message
  
  @selenium
  @no-database-cleaner
  Scenario: COA selects an application and upload a CSV file of 4 providers
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see simple acknowledgement messages

  @selenium
  @no-database-cleaner
  Scenario: COA upload NPI providers already registered with selected
  destination application
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see simple acknowledgement messages

  @selenium
  @no-database-cleaner
  Scenario: COA upload NPI providers already registered with the COA's
  organization
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be successfully logged out of the application
    Given a valid COA having NPI providers already registered with the COAs organization
    When I go to login page
    And I fill in the username and password
    And I press "Sign in"
    Then I should see success message
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see simple acknowledgement messages

  @selenium
  @no-database-cleaner
  Scenario: COA upload NPI providers already registered with an organization other than the COA's organization
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be successfully logged out of the application
    Given a valid COA
    When I go to login page
    And I fill in the username and password
    And I press "Sign in"
    Then I should see success message
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to see simple acknowledgement messages