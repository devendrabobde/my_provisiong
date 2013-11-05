Feature: Admin manages admin users
  In order to manage other administrators
  As an admin user
  I will use the ActiveAdmin resource

  Background:
    Given the following admin user exists:
      | email     | admin@example.com |
      | password  | password          |
      | user_name | ReenhancedAdmin   |
    And I am logged in with "admin@example.com/password"
    And I click "Admin Users" within the admin menu bar

  Scenario: List users
    Then the index should contain only the following columns:
      | User Name          |
      | Email              |
      | Current Sign In At |
      | Last Sign In At    |
      | Sign In Count      |

  Scenario: Add new admin user
    When I click "New Admin User"
    And I fill in "User name" with "Nick-Hance"
    And I fill in "Email" with "test@example.com"
    And I fill in "Password*" with "password"
    And I fill in "Password confirmation" with "password"
    And I check "Disabled"
    And I press "Create Admin user"
    Then I should see "Admin user was successfully created"
    And the admin user "Nick-Hance" should be disabled

  Scenario: See an error message when the username already exists
    When I click "New Admin User"
    And I fill in "User name" with "ReenhancedAdmin"
    And I fill in "Email" with "test@example.com"
    And I fill in "Password*" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Create Admin user"
    Then I should see "has already been taken. Try suggested usernames: ReenhancedAdmin1, ReenhancedAdmin2"

  Scenario: Edit admin user without changing password
    When I click "Edit"
    And I fill in "User name" with "Nick-Hance"
    And I press "Update Admin user"
    Then I should see "Admin user was successfully updated."

  Scenario: View admin user
    When I click "View"
    Then I should see "ReenhancedAdmin"
    And I should see "admin@example.com"
    And I should see "Sign In Count"
    And I should see "Current Sign In At"
    And I should see "Last Sign In At"
    And I should see "Current Sign In Ip"
    And I should see "Last Sign In Ip"
    And I should see "Created At"
    And I should see "Updated At"
    And I should see "Disabled"
    But I should not see "Encrypted Password"
    And I should not see "Created Date As Number"
    And I should not see "Comments"

  Scenario: Filter admin users
    When I fill in "Search Email" with "no results"
    And I press "Filter"
    Then I should see "No Admin Users found"
    When I fill in "Search Email" with "EXAMPLE.com"
    And I press "Filter"
    Then I should see "admin@example.com"
    And the "Search Email" field should contain "EXAMPLE.com"

