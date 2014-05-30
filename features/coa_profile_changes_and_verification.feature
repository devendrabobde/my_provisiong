Feature: COA Profile Changes and Verification End To End
    
@selenium
@no-database-cleaner
Scenario: COA Updates Password. Relogin to verify old password does not work. Can only log in using the newly reset password.
  Given a valid COA details
  When I go to signin page
  And I fill in username and password
  And I click "Sign in"
  Given I go to application page
  When I click on change password link in setting section
  Then I should be able to see change password form
  And I click on update with the information that needs to be changed including correct old password  
  Then I should see success message You updated your account successfully
  Then I should be successfully logged out of the application
  And I fill in username and password
  And I click "Sign in"
  Then I should see an error message indicating password is incorrect
  And I fill in username and updated password
  And I click "Sign in"
  Then I should see success message


@selenium
@no-database-cleaner
Scenario: COA edits personal information. Re-login to verify that information edited is still there.
  Given a valid COA details
  When I go to signin page
  And I fill in username and password
  And I click "Sign in"
  Given I go to application page
  And I click on edit account link in setting section
  Then I should be able to see edit account form
  And I click on update with the information that needs to be changed including correct personal information
  Then I should see success message You updated your account successfully
  Then I should be successfully logged out of the application
  When I go to signin page
  And I fill in username and password
  And I click "Sign in"
  And I click on edit account link in setting section
  Then I should see the information being updated

