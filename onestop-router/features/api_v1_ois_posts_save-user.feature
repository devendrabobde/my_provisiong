Feature: OIS posts 'save-user' API
  In order to add a user to an OIS
  As an OIS
  I can make a post request to the 'save-user' API

  Background:
    Given the following ois exists:
      | id             | 550e8400-e29b-41d4-a716-446655440000 |
      | ois_name       | DFID                                 |
      | enrollment_url | http://rambomd.com/login             |
      | idp_level      | 1                                    |

  Scenario: OIS makes POST request to 'save-user' for a new user
    When I make an API POST request to '/api/v1/ois/save-user' as a valid OIS with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
    Then the OIS should have a user with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
      | enabled    | 1          |
    And the HTTP headers should contain:
      | status_code | 200 |
    And the last User should have been modified by the Ois "DFID"

  Scenario: OIS makes POST request to 'save-user' for an existing user
    Given the following user exists:
      | npi        | 1234567890  |
      | first_name | Joey        |
      | last_name  | Bagofdonuts |
      | enabled    | 1           |
    When I make an API POST request to '/api/v1/ois/save-user' as a valid OIS with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
      | enabled    | 0          |
    Then the OIS should have a user with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
      | enabled    | 0          |

  @allow-rescue
  Scenario Outline: OIS makes POST request to 'save-user' with invalid user data
    When I make an API POST request to '/api/v1/ois/save-user' as a valid OIS with:
      | npi        | <npi>        |
      | first_name | <first_name> |
      | last_name  | <last_name>  |
    Then the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "invalid-request",
                "message": "The following parameters are invalid: <invalid_params>"
              }
            ]
        }
      """

    Examples:
      | npi        | first_name | last_name | invalid_params             |
      |            | Carlos     | Casteneda | npi                        |
      | 1234567890 |            | Casteneda | first_name                 |
      | 1234567890 | Carlos     |           | last_name                  |
      |            |            |           | npi, first_name, last_name |
