Feature: COA activities

Background:
  Given a valid COA associated with "Ruby Clinic New York"
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message

@selenium
@no-database-cleaner
Scenario: As a COA, I should see the correct organization name to which I am associated
  Given I go to application page
  Then I should see "Organization : Ruby Clinic New York"

@selenium
@no-database-cleaner
Scenario: As a COA, I should be able to logout if I click on browser's back button
  Given I go to application page
  And I click on browser back button
  Then I should be able to dismis alert box
  When I click on browser back button and click on ok in alert box
  Then I should be able to see You have been logged out. Please sign in to continue using the system

@selenium
@no-database-cleaner
Scenario: As a COA, I should be able to logout if I click on browser's back button from any page
  Given I go to application page
  Given I select an application    
  And I click on the first audit record
  When I click on browser back button and click on ok in alert box
  Then I should be able to see You have been logged out. Please sign in to continue using the system