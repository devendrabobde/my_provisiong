Feature: COA reset their password when they log in the first time
    
@selenium
@no-database-cleaner
Scenario: COA Reset Password When Log In First Time
  Given a valid COA details
  When I go to signin page
  And I fill in username and password
  And I click "Sign in"
  Given I visit application page
  Then I should be able to see Change Password form
  And I click on update with the new password and correct old password
  Then I should see success message as You updated your account successfully