Feature: SA to manage COA
  A Super Admin Should be able to manage COAs of any organization

Background:
  Given a valid SA
  When I go to login page
  And I fill in the username and password for SA
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

@selenium
@no-database-cleaner
Scenario: SA to delete a COA from any organization
	Given I select an organization to see the COAs
	Then I should see the list of all COAs of that organization
	And I should be able to delete any COA from that list
	Then the COA should be deactivated

@selenium
@no-database-cleaner
Scenario: SA to update a COA from any organization
	Given I select an organization to see the COAs
	Then I should see the list of all COAs of that organization
	When I click on edit for any COA
	Then I should see edit coa form for SA
	When I update the edit COA form with proper fields
	Then the COA should be updated with username and password

@selenium
@no-database-cleaner
Scenario: SA to view a COA from any organization
	Given I select an organization to see the COAs
	Then I should see the list of all COAs of that organization
	When I click on show for any COA
	Then I should be able to view that COAs details

@selenium
@no-database-cleaner
Scenario: SA to activate a COA from any organization
	Given I select an organization to see the COAs
	Then I should see the list of all COAs of that organization
	Then I should be able to activate an inactive COA