Feature: Admin manages applications
  In order to manage client applications
  As an admin user
  I will use the ActiveAdmin resource

  Background:
    Given the following admin user exists:
      | email    | admin@example.com |
      | password | password          |
    And the default client preference exists
    And the following ois client exists:
      | client_name     | Reenhanced LLC |
      | client_password | 12345678911234567892123456789312345678941234567895 |
    And I am logged in with "admin@example.com/password"
    And I click "Applications" within the admin menu bar

  Scenario: List applications
    Then the index should contain only the following columns:
      | Client Name       |
      | Ip Address Concat |

  Scenario: Add new application
    When I click "New Application"
    Then I should not see "Created date"
    And I should not see "Last update date"
    And I should not see "Slug"
    And I should not see "Created date as number"
    And I should not see "Last update date as number"
    When I fill in the following:
      | Client name       | BuildBetterSoftware.com |
      | Ip address concat | 10.1.1.1                |
    And I select "OneStop Default" from "Preferences"
    And I check "Disabled"
    And I press "Save"
    Then I should see "was successfully created"
    And the last OisClient should have been last modified by the admin user "admin@example.com"

  Scenario: View application
    When I click "View"
    Then I should see "Reenhanced LLC"
    And I should see "Createddate"
    And I should see "Lastupdatedate"
    And I should see "Disabled"
    But I should not see "Comments"

  @javascript
  Scenario: Generate new password
    Given the next password generated will be "reenhancedcreatesbusinessvaluebysolvingproblemstherightway"
    When I click "Edit"
    Then the "Client password" field should contain "12345678911234567892123456789312345678941234567895"
    When I press "Generate new password"
    And I click "Show Password"
    Then the "Client password" field should contain "reenhancedcreatesbusinessvaluebysolvingproblemstherightway"
    When I press "Save"
    Then I should see "was successfully updated"
    And I should see "reenhancedcreatesbusinessvaluebysolvingproblemstherightway"

  @javascript
  Scenario: Password field visibility can be toggled
    When I click "Edit"
    Then the "Client password" field should be masked
    When I click "Show Password"
    Then the "Client password" field should be unmasked

  Scenario: Filter applications
    When I fill in "Search Client name" with "no results"
    And I press "Filter"
    Then I should see "No Applications found"
    When I fill in "Search Client name" with "Reenhanced"
    And I press "Filter"
    Then I should see "Reenhanced"
