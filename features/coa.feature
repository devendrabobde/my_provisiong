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