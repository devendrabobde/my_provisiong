Feature: COA reset their password when they log in the first time

Background:
  Given a valid COA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
    
@selenium
@no-database-cleaner
Scenario: COA Reset Password When Log In First Time
  Given I visit application page
  Then I should be able to see Change Password form
  And I click on update with the new password and correct old password
  Then I should see success message as You updated your account successfully