Feature: SA to manage organization
  A Super Admin Should Be Able to manage organizations

Background:
  Given a valid SA
  When I go to login page
  And I fill in the username and password for SA
  And I press "Sign in"
  Then I should see success message

@selenium
@no-database-cleaner
Scenario: SA proceeds to add a new organization
  Given I go to admin home page
  And I should be able to see the tabs on the top of the main screen as Onestop Logo, Setting and Username
  And I should be able to see Onestop tab as defalut tab
  Then I click on Onestop default tab
  And I should be able to see the tabs on the top of the main screen as Onestop Logo, Setting and Username
	And I click on create organization
	Then I should see a form
  And I click on create organization without filling up the mandatory fields
  Then I should be able to see error validation messages for mandatory fields
  And I fill the fields on form with incorrect inputs, I should see input validation message
	When I fill in form with proper organization details and submit
	Then I should see success message and organization details

@selenium
@no-database-cleaner
Scenario: SA views all organizations
  Given I go to admin home page 
  Then I should see a list of all organizations

@selenium
@no-database-cleaner
Scenario: SA views all organizations with pagination
  Given I have more than ten organization
  Then I should see a first ten organizations
  And I click on next button
  Then I should see a next ten organizations
  And I should be able to verify dropdown for selecting the number of displayed Organizations has 10, 25, 50 and 100
  And I should be able to search for a organization by entering text in search box
  Then I should be able to select 25 from dropdown
  And I should be able to see 25 organizations
  Then I should be able to select 50 from dropdown
  And I should be able to see 50 organizations

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
Scenario: SA views setting options
  Given I go to admin home page 
  Then I should be able to see two setting options as Edit Personal Info and Change Password

@selenium
@no-database-cleaner
Scenario: SA views an organization
  Given I go to admin home page 
  Then I should see a list of all organizations
  And I should be able to view COAs of any organization

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