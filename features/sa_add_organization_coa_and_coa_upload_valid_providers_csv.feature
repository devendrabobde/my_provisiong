Feature: Super Admin creates a new organization and add a new COA. Log in using this new COA and upload a valid csv file successfully

Background:
  Given a valid SA
  When I go to login page
  And I fill in the username and password for SA
  And I press "Sign in"
  Then I should see success message

@selenium
@no-database-cleaner
Scenario: Super Admin creates a new organization 
  Given I go to admin home page
  And I click on create organization
  Then I should see a form
  When I fill in form with proper organization details and submit
  Then I should see success message and organization details

@selenium
@no-database-cleaner
Scenario: Super Admin add a new COA to created organization
  Given I go to admin home page
  Given I select an organization to see the COAs
  Then I should see the list of all COAs of that organization
  When I proceed for creating the COA
  Then I should see the form for creating the coa
  When I submit the form with proper values
  Then I should see the created CAO saved in provisioning db with username and password

@selenium
@no-database-cleaner
Scenario: COA Log in successfully and upload a valid csv file successfully
  And I should be successfully logged out of the application
  Given a valid COA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message
  And I should see correct screen title
  And I should see application selection list
  And I should see file selection button
  And I should see application csv template download button
  And I should see correct section names
  Given I select an application
  When I select a csv file of 4 providers
  And I clicks upload button
  And I should be able to see correct file upload message
  And I should be able to see progress bar
  And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
  And I should be able to associate provider with COA
  And I should be able to add audit data in Provisioning DB
  And I should be able to see simple acknowledgement messages