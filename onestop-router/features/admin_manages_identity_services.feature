Feature: Admin manages identity services
  In order to manage identity services
  As an admin user
  I will use the ActiveAdmin resource

  Background:
    Given the following admin user exists:
      | email    | admin@example.com |
      | password | password          |
    And the following organization exists:
      | organization_name | Reenhanced |
    And the following ois exists:
      | ois_name     | Reenhanced LLC |
      | ois_password | 12345678911234567892123456789312345678941234567895 |
    And I am logged in with "admin@example.com/password"
    And I click "Identity Services" within the admin menu bar

  Scenario: List identity services
    Then the index should contain only the following columns:
      | Identity Service Name |
      | Ip Address Concat     |

  Scenario: Add new identity service
    When I click "New Identity Service"
    Then I should not see "Created date"
    And I should not see "Last update date"
    And I should not see "Slug"
    And I should not see "Created date as number"
    And I should not see "Last update date as number"
    When I fill in the following:
      | Identity Service Name     | BuildBetterSoftware.com                            |
      | Identity Service password | 12345678911234567892123456789312345678941234567895 |
      | Ip address concat         | 10.1.1.1                                           |
      | Outgoing service id       | 51                                                 |
      | Outgoing service password | secrets                                            |
      | Enrollment url            | http://www.reenhanced.com/contact                  |
      | Authentication url        | http://www.reenhanced.com/                         |
      | Idp level                 | 3                                                  |
    And I select "Reenhanced" from "Organization"
    And I check "Disabled"
    And I press "Save"
    Then I should see "was successfully created"

  Scenario: View identity service
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
    Then the "Identity Service password" field should contain "12345678911234567892123456789312345678941234567895"
    When I press "Generate new password"
    Then the "Identity Service password" field should contain "reenhancedcreatesbusinessvaluebysolvingproblemstherightway"
    When I press "Save"
    Then I should see "was successfully updated"
    And I should see "reenhancedcreatesbusinessvaluebysolvingproblemstherightway"

  @javascript
  Scenario: Password field visibility can be toggled
    When I click "Edit"
    Then the "Identity Service password" field should be masked
    When I click "Show Password"
    Then the "Identity Service password" field should be unmasked

  Scenario: Filter identity services
    When I fill in "Search Ois name" with "no results"
    And I press "Filter"
    Then I should see "No Identity Services found"
    When I fill in "Search Ois name" with "Reenhanced"
    And I press "Filter"
    Then I should see "Reenhanced"
