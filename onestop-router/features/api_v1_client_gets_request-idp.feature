Feature: Client gets 'request-idp' API
  In order to get an enrollment URL for a OneStop Identity Service
  As a client
  I can make a request to the 'request-idp' API

  Background:
    Given the following ois exists:
      | id             | 36f3b5d4-8896-440c-8a2a-0e57301cf2cf |
      | ois_name       | RamboMD                              |
      | enrollment_url | http://rambomd.com/register          |
      | idp_level      | 1                                    |
    And the following ois exists:
      | id             | 4d9ba577-f9df-454d-a7e4-02af696ee979 |
      | ois_name       | FacebookMD                           |
      | enrollment_url | http://facebook.com/onestop/register |
      | idp_level      | 2                                    |
    And I have a user for the "RamboMD" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
    And I have a user for the "FacebookMD" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |

  Scenario: Client makes GET request to 'request-idp'
    When I make an API GET request to '/api/v1/client/request-idp' as a valid client with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
    Then the JSON response should be:
      """
        [
          {
            "ois_name": "RamboMD",
            "idp_level": 1,
            "enrollment_url": "http://rambomd.com/register"
          },
          {
            "ois_name": "FacebookMD",
            "idp_level": 2,
            "enrollment_url": "http://facebook.com/onestop/register"
          }
        ]
      """
    And the request should have been logged

  Scenario: Client makes GET request to 'request-idp' with an IDP level
    When I make an API GET request to '/api/v1/client/request-idp' as a valid client with:
      | npi           | 1234567890 |
      | first_name    | Carlos     |
      | last_name     | Casteneda  |
      | min_idp_level | 2          |
    Then the JSON response should be:
      """
        [
          {
            "ois_name": "FacebookMD",
            "idp_level": 2,
            "enrollment_url": "http://facebook.com/onestop/register"
          }
        ]
      """
    And the request should have been logged

  Scenario: Client makes GET request to 'request-idp' with an OIS id
    When I make an API GET request to '/api/v1/client/request-idp' as a valid client with:
      | npi        | 1234567890                           |
      | first_name | Carlos                               |
      | last_name  | Casteneda                            |
      | ois_id     | 36f3b5d4-8896-440c-8a2a-0e57301cf2cf |
    Then the JSON response should be:
      """
        [
          {
            "ois_name": "RamboMD",
            "idp_level": 1,
            "enrollment_url": "http://rambomd.com/register"
          }
        ]
      """
    And the request should have been logged

  Scenario: Client makes GET request to 'request-idp' with non-existing NPI
    When I make an API GET request to '/api/v1/client/request-idp' as a valid client with:
      | npi        | 1231231230 |
      | first_name | Carlos     |
      | last_name  | Castaneda  |
    Then the HTTP headers should contain:
      | status_code | 200 |
    And the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "not-found",
                "message": "User not found"
              }
            ]
        }
      """
    And the request should have been logged without a client id

  Scenario Outline: Client makes GET request to 'request-idp' with invalid user data
    When I make an API GET request to '/api/v1/client/request-idp' as a valid client with:
      | npi        | <npi>        |
      | first_name | <first_name> |
      | last_name  | <last_name>  |
    Then the HTTP headers should contain:
      | status_code | 200 |
    And the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "npi-name-mismatch",
                "message": "NPI Name Mismatch"
              }
            ]
        }
      """
    And the request should have been logged without a client id

    Examples:
      | npi        | first_name | last_name |
      | 1234567890 | Carl       | Casteneda |
      | 1234567890 | Carlos     | Sanchez   |
