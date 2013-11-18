Feature: SA to add new organization
  A Super Admin Should Be Able to add new organization

Background:
  Given a valid SA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"

@selenium
@no-database-cleaner
Scenario: SA proceeds to add a new organization
	Given I click on create organization
	Then I should see a form
	When I fill in form with proper organization details and submit
	Then I should see success message and organization details
