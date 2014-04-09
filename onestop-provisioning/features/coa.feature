Feature: COA account
  In order to manage the COA account
  We have to cover all the scenarios


@selenium
@no-database-cleaner
Scenario: As a COA user, when I press back button after logout then I should not be redirect back to Login page. 
  Given I go to the application home page
  And I click on the logout
  And I should see "Sign in"
  And I click browser back button
  Then I should be redirected to login page
  And I should see "You need to sign in or sign up before continuing."
