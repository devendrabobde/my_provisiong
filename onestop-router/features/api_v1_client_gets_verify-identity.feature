Feature: Client gets 'verify-identity' API
  In order to get a URL for a user to authenticate with a OneStop Identity Service
  As a client
  I can make a request to the 'verify-identity' API

  Background:
    Given the following ois exists:
      | id                 | 9082a027-cddf-416d-86a6-09f8e27ed53f |
      | ois_name           | RamboMD                              |
      | authentication_url | http://rambomd.com/login             |
      | idp_level          | 1                                    |
    And the following ois exists:
      | id                 | b4c7237d-7c31-443f-9d9e-5d092dde5acb |
      | ois_name           | FacebookMD                           |
      | authentication_url | http://facebook.com/onestop/login    |
      | idp_level          | 2                                    |
    And I have a user for the "RamboMD" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
    And I have a user for the "FacebookMD" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |

  Scenario: Client makes GET request to 'verify-identity'
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
    Then the JSON response should be:
      """
        [
          {
            "ois_name": "RamboMD",
            "idp_level": 1,
            "authentication_url": "http://rambomd.com/login"
          },
          {
            "ois_name": "FacebookMD",
            "idp_level": 2,
            "authentication_url": "http://facebook.com/onestop/login"
          }
        ]
      """
    And the request should have been logged

  Scenario: Client makes GET request to 'verify-identity' with a minimum IDP level
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
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
            "authentication_url": "http://facebook.com/onestop/login"
          }
        ]
      """
    And the request should have been logged

  Scenario Outline: Client makes GET request to 'verify-identity' with an OIS id or slug
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
      | npi        | 1234567890       |
      | first_name | Carlos           |
      | last_name  | Casteneda        |
      | ois_id     | <ois_slug_or_id> |
    Then the JSON response should be:
      """
        [
          {
            "ois_name": "RamboMD",
            "idp_level": 1,
            "authentication_url": "http://rambomd.com/login"
          }
        ]
      """
    And the request should have been logged

    Examples:
      | ois_slug_or_id                       |
      | 9082a027-cddf-416d-86a6-09f8e27ed53f |
      | rambomd                              |

  Scenario: Client makes GET request to 'verify-identity' with an OIS id or slug that doesn't exist
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
      | npi        | 1234567890       |
      | first_name | Carlos           |
      | last_name  | Casteneda        |
      | ois_id     | 0                |
    Then the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "not-found",
                "message": "Record not found"
              }
            ]
        }
      """
    And the request should have been logged without a client id

  Scenario: Client makes GET request to 'verify-identity' with an NPI that doesn't exist
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
      | npi        | 1231231230 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
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

  Scenario Outline: Client makes GET request to 'verify-identity' with invalid user data
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
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
      # invalid first name
      | 1234567890 | Carl       | Casteneda |
      # invalid last name
      | 1234567890 | Carlos     | Sanchez   |

  Scenario: Client makes GET request to 'verify-identity' with missing npi param
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
      | first_name | Carlos    |
      | last_name  | Casteneda |
    Then the HTTP headers should contain:
      | status_code | 200 |
    And the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "invalid-request",
                "message": "Invalid User Request"
              }
            ]
        }
      """
    And the request should have been logged without a client id

  Scenario: Client makes GET request to 'verify-identity' with missing first_name param
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
      | npi        | 1234567890 |
      | last_name  | Casteneda  |
    Then the HTTP headers should contain:
      | status_code | 200 |
    And the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "invalid-request",
                "message": "Invalid User Request"
              }
            ]
        }
      """
    And the request should have been logged without a client id

  Scenario: Client makes GET request to 'verify-identity' with missing last_name param
    When I make an API GET request to '/api/v1/client/verify-identity' as a valid client with:
      | npi        | 1234567890 |
      | last_name  | Casteneda  |
    Then the HTTP headers should contain:
      | status_code | 200 |
    And the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "invalid-request",
                "message": "Invalid User Request"
              }
            ]
        }
      """
    And the request should have been logged without a client id
