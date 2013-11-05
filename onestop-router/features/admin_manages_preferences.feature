Feature: Admin manages preferences
  In order to manage client preferences
  As an admin user
  I will use the ActiveAdmin resource

  Background:
    Given the following admin user exists:
      | email    | admin@example.com |
      | password | password          |
    And the following ois client preference exists:
      | preference_name | Reenhanced, LLC |
    And I am logged in with "admin@example.com/password"
    And I click "Preferences" within the admin menu bar

  Scenario: List Preferences
    Then the index should contain only the following columns:
      | Preference Name |
      | Faq Url         |
      | Help Url        |
      | Logo Url        |

  Scenario: Add new Preferences
    When I click "New Preferences"
    Then I should not see "Createddate"
    And I should not see "Lastupdatedate"
    And I should not see "Slug"
    When I fill in the following:
      | Preference name | Reenhanced LLC                            |
      | Faq url         | http://www.reenhanced.com/faq             |
      | Help url        | http://www.reenhanced.com/help            |
      | Logo url        | http://www.reenhanced.com/images/logo.png |
    And I press "Save"
    Then I should see "was successfully created"

  Scenario: View Preferences
    When I click "View"
    Then I should see "Reenhanced, LLC"
    And I should see "Createddate"
    And I should see "Lastupdatedate"
    But I should not see "Comments"

  Scenario: Filter Preferences
    When I fill in "Search Preference name" with "no results"
    And I press "Filter"
    Then I should see "No Preferences found"
    When I fill in "Search Preference name" with "Reenhanced"
    And I press "Filter"
    Then I should see "Reenhanced"
