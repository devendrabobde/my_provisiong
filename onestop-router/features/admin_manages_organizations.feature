Feature: Admin manages organizations
  In order to manage organizations
  As an admin user
  I will use the ActiveAdmin resource

  Background:
    Given the following admin user exists:
      | email    | admin@example.com |
      | password | password          |
    And the following organization exists:
      | organization_name | Reenhanced, LLC |
    And I am logged in with "admin@example.com/password"
    And I click "Organizations" within the admin menu bar

  Scenario: List Organizations
    Then the index should contain only the following columns:
      | Organization NPI   |
      | Organization Name  |
      | Contact First Name |
      | Contact Last Name  |

  Scenario: Add new Organizations
    When I click "New Organization"
    Then I should not see "Createddate"
    And I should not see "Lastupdatedate"
    And I should not see "Slug"
    When I fill in the following:
      | Organization npi  | 0123456789              |
      | Organization name | BuildBetterSoftware.com |
      | Address1          | 312 West Broad Street   |
      | Address2          | n/a                     |
      | City              | Quakertown              |
      | State code        | PA                      |
      | Postal code       | 18951                   |
    And I fill in the following:
      | First Name | Nicholas              |
      | Last Name  | Hance                 |
      | Phone      | 215.804.9408          |
      | Email      | nhance@reenhanced.com |
    And I check "Disabled"
    And I press "Save"
    Then I should see "was successfully created"

  Scenario: View Organizations
    When I click "View"
    Then I should see "Reenhanced, LLC"
    And I should see "Createddate"
    And I should see "Lastupdatedate"
    But I should not see "Comments"

  Scenario: Filter Organizations
    When I fill in "Search Organization name" with "no results"
    And I press "Filter"
    Then I should see "No Organizations found"
    When I fill in "Search Organization name" with "Reenhanced"
    And I press "Filter"
    Then I should see "Reenhanced"
