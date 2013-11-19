Feature: SA to manage organization
  A Super Admin Should Be Able to manage organizations

Background:
  Given a valid SA
  When I go to login page
  And I fill in the username and password
  And I press "Sign in"
  Then I should see success message

@selenium
@no-database-cleaner
Scenario: SA proceeds to add a new organization
  Given I go to admin home page
	And I click on create organization
	Then I should see a form
	When I fill in form with proper organization details and submit
	Then I should see success message and organization details

@selenium
@no-database-cleaner
Scenario: SA views all organizations
  Given I go to admin home page 
  Then I should see a list of all organizations

@selenium
@no-database-cleaner
Scenario: SA proceeds to update an organization
  Given I go to admin home page
  Then I should see a list of all organizations
  When I click edit for an organization
  Then I should see edit organization form
  When I make changes and update the organization
  Then I should see success message for organization update and organization details

@selenium
@no-database-cleaner
Scenario: SA views an organization
  Given I go to admin home page 
  Then I should see a list of all organizations
  And I should be able to view COAs of any organization
  And I should be able to view applications of any organization

@selenium
@no-database-cleaner
Scenario: SA deletes an organization
  Given I go to admin home page 
  Then I should see a list of all organizations
  And I should be able to delete an organization

@selenium
@no-database-cleaner
Scenario: SA activates an organization
  Given I go to admin home page 
  Then I should see a list of all organizations
  And I should be able to activate an organization which is inactive