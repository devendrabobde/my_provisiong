Feature: Super Admin deactivates a COA within an Organization. Deactivated COA is unable to login, validate the error message. Other COA within that Organization should be able to login and upload a csv successfully

Background:
  Given a valid SA
  When I go to login page
  And I fill in the username and password for SA
  And I press "Sign in"
  Then I should see success message

@selenium
@no-database-cleaner
Scenario: SA deactivates an organization and COA Log in from the deactivated organization the Login should fail with correct validation message
  Given I go to admin home page 
  Then I should see a list of all organizations
  And I should be able to deactivate an organization
  And I should be successfully logged out of the application
  When I go to login page
  And I fill in with the username and password
  And I press "Sign in"
  Then I should see login failed validation message

@selenium
@no-database-cleaner
Scenario: Other 2 COA within the deactivated Organization should be able to login and upload a csv successfully
  Given I go to admin home page 
  Then I should see a list of all organizations
  And I should be able to deactivate an organization
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