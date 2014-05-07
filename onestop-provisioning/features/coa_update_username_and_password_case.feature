Feature: COA update username and password
    
@selenium
@no-database-cleaner
Scenario: COA Updates Username and Password
  Given a valid COA details
  When I go to signin page
  And I fill in username and password
  And I click "Sign in"
  Given I go to application page
  And I click on edit account link in setting section
  Then I should be able to see edit account form
  And I click on update with the information that needs to be changed including correct old password
  Then I should see success message You updated your account successfully
  When I click on edit account link in setting section
  And I click on update with the information that needs to be changed including correct personal information
  Then I should see success message You updated your account successfully