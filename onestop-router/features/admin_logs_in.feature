Feature: Admin logs in
  In order to access the admin UI
  As an admin user
  I will login to the administration section

  Background:
    Given the following admin user exists:
      | user_name | admin             |
      | email     | admin@example.com |
      | password  | password          |

  Scenario: Valid administrator logs in with email
    When I go to the admin login page
    And I fill in "Login" with "admin@example.com"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should be logged in as "admin"

  Scenario: Valid administrator logs in with login
    When I go to the admin login page
    And I fill in "Login" with "admin"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should be logged in as "admin"

  Scenario: Disabled administrator cannot log in
    Given the administrator "admin@example.com" is disabled
    When I go to the admin login page
    And I fill in "Login" with "admin"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should not be logged in
    And I should see "Your account is disabled."
