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
  And I click on update without entering required fields
  Then I should see error message as This field is required
  And I fill in system unexpected password in new password field
  Then I should see error message as Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character
  And I fill in dissimilar value in password confirmation field
  Then I should see error message as Please enter the same value again
  And I click on update with the new password and correct old password
  Then I should see success message as You updated your account successfully

@selenium
@no-database-cleaner
Scenario: Validation should fail when COA Reset Password using old password When Log In First Time
  Given a valid COA details
  When I go to signin page
  And I fill in username and password
  And I click "Sign in"
  Given I visit application page
  Then I should be able to see Change Password form
  And I click on update with the new password which I had used in past
  Then I should see error message as Password was already taken in the past

@selenium
@no-database-cleaner
Scenario: Validation should fail when COA Reset Password using incorrect old password When Log In First Time
  Given a valid COA details
  When I go to signin page
  And I fill in username and password
  And I click "Sign in"
  Given I visit application page
  Then I should be able to see Change Password form
  And I click on update with incorrect old password
  Then I should see error message as Current password is invalid