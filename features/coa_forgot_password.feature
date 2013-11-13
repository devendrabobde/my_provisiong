Feature: COA forgot password
  In order to retrieve lost password
  As a user of this site
  I want to reset it
  
@selenium
@no-database-cleaner
Scenario: COA forgot password
  When I go to application home page
  Then I should be able to see forgot password link
  And I should be able to click on forgot password link
  When I enter email
  And I press Send me reset password instructions button
  Then I sould be able to see You will receive an email with instructions about how to reset your password in a few minutes.