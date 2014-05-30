Feature: Super Admin deactivates an Organization. Login using any COA within that org. Login should fail, validate the error message

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