Feature: SA audits upload history
	As a Super Admin, I Should be able audit the upload history of any COA from any organization

Background:
	Given a valid COA
	When I go to login page
	And I fill in the username and password
	And I press "Sign in"
	Then I should see success message
	Given I select an application
	When I select a csv file of 4 providers
	And I clicks upload button
	And I should be able to see progress bar
	And I should be able to verify clean provider data in Provisioning DB, invokes BatchUploadDest to transmit providers to destination OIS and receive response from destination OIS, invokes BatchUpload to transmit providers to OIS Router and receives success message from OIS Router
	And I should be successfully logged out of the application	
	Given a valid SA
	When I go to login page
	And I fill in the username and password for SA
	And I press "Sign in"
	Then I should see success message

@selenium
@no-database-cleaner
Scenario: SA audits upload history
	Given I click on the organization of COA
	Then I should be able to see a list of all csv files uploaded by provider
	When I click on any csv file from the list
	Then I should be able to see the provider details
	And I should be able to download any previously updated csv file with its providers