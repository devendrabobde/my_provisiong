Feature: COA upload NPI providers and completes successfully
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
    And I should be able to see Onestop tab as defalut tab
    Then I click on Onestop default tab
    And I should be able to see the tabs on the top of the main screen as Onestop Logo, Setting, Username and organization 
    And I should see correct screen title
    And I should see application selection list
    And I should see file selection button
    And I should see application csv template download button
    And I should see correct section names
    And I should be able to see the tabs on the top of the main screen as Onestop Logo, Setting, Username and organization

  @selenium
  @no-database-cleaner
  Scenario: COA selects to start new upload
    Given I go to application page
    And I click on file upload button
    Then I should see message Please select application and a CSV file to initiate the provisioning process
    And I select an invalid file with .png extension
    Then I should see error validation message
    And I select file to upload with any of the extensions like .doc other than csv, I should see error validation message
    And I select file to upload with any of the extensions like .pdf other than csv, I should see error validation message
    And I select file to upload with any of the extensions like .xml other than csv, I should see error validation message

  @selenium
  @no-database-cleaner
  Scenario: COA views all files with pagination
    Given I go to application page
    And I should be able to verify dropdown for selecting the number of displayed files has 10, 25, 50 and 100
    And I should be able to verify 10 entries per page
    Given I select an application
    Then I should be able to select 25 from file dropdown
    And I should be able to see 25 files
    Then I should be able to select 50 from file dropdown
    And I should be able to see 50 files

  @selenium
  @no-database-cleaner
  Scenario: COA views all files with pagination
    Given I go to application page
    Given I select an application
    And I should be able to see download sample data file link
    And I click on download sample data file link
    Then I should be able to see download dialog

  @selenium
  @no-database-cleaner
  Scenario: COA search for files with pagination
    Given I go to application page
    And I should be able to verify the search box
    And I should be able to search for a file by entering text in search box
    And I should be able to see 25 files

  @selenium
  @no-database-cleaner
  Scenario: COA varifies the presence of Previous and Next buttons in pagination view
    Given I go to application page
    And I should be able to verify previous and next button
    Given I select an application    
    And I click on the next button
    Then I should see the correct files
    And I click on the previous button
    Then I should see the correct files

  @selenium
  @no-database-cleaner
  Scenario: COA varifies the total NPI processed gives the number of NPI's processed
    Given I go to application page
    Given I select an application    
    Then I should see the correct total number of NPI processed
    And I click on the first audit record
    Then I should be able to see total npi processed on the top of page

  @selenium
  @no-database-cleaner
  Scenario: COA selects an application and upload a CSV file of 4 providers
    Given I select an application
    When I select a csv file of 4 providers
    And I clicks upload button
    And I should be able to see correct file upload message
    And I should be able to see progress bar
    And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
    And I should be able to associate provider with COA
    And I should be able to add audit data in Provisioning DB
    And I should be able to see simple acknowledgement messages