Feature: SA to manage COA
  A Super Admin Should be able to manage COAs of any organization

Background:
  Given a valid SA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message

@selenium
@no-database-cleaner
Scenario: SA to view all COAs of any organization
	Given I select an organization to see the COAs
	Then I should see the list of all COAs of that organization

@selenium
@no-database-cleaner
Scenario: SA to add COA to any organization
	Given I select an organization to see the COAs
	When I proceed for creating the COA
	Then I should see the form for creating the coa
	When I submit the form with proper values
	Then I should see the created CAO saved in provisioning db with username and password