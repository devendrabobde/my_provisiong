Feature: Client gets 'verify-id-token' API
  In order to validate a client's ois user token
  As a client
  I can make a get request to the 'verify-id-token' API

  Background:
    Given the following ois exists:
      | id             | 9082a027-cddf-416d-86a6-09f8e27ed53f |
      | ois_name       | RamboMD                              |
      | enrollment_url | http://rambomd.com/signup            |
      | idp_level      | 1                                    |
    And the following ois client exists:
      | client_name     | Reenhanced LLC |
      | client_password | 12345678911234567892123456789312345678941234567895 |
    And I have a user for the "RamboMD" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
    And the user has the following ois user token:
      | token              | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx65 |
      | verified_timestamp |                                                                   |

  Scenario: Client makes GET request to 'verify-id-token'
    When I make an API GET request to '/api/v1/client/verify-id-token' as a valid client with:
      | token | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx65 |
    Then the ois user token should be verified
    And the JSON response should be:
      """
        {
          "first_name": "Carlos",
          "idp_level": 1,
          "last_name": "Casteneda",
          "npi": "1234567890"
        }
      """
    And the last OisUserToken should have been last modified by the client "Reenhanced LLC"

  Scenario: Client makes GET request to 'verify-id-token' without a token
    When I make an API GET request to '/api/v1/client/verify-id-token' as a valid client
    Then the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "invalid-request",
                "message": "Token is required"
              }
            ]
        }
      """

  Scenario: Client makes GET request to 'verify-id-token' with a token that doesn't exist
    When I make an API GET request to '/api/v1/client/verify-id-token' as a valid client with:
      | token | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx50 |
    Then the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "not-found",
                "message": "Token not found"
              }
            ]
        }
      """

  Scenario: Client makes GET request to 'verify-id-token' with an expired token
    Given today is "01-APR-2013"
    And I have a user for the "RamboMD" identity service with:
      | npi         | 1234567890               |
      | firstname   | Carlos                   |
      | lastname    | Casteneda                |
    And the user has the following ois user token:
      | token              | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx75 |
      | verified_timestamp |                                                                             |
      | createddate        | Tue 01-Jan-2013 01:00:00                                                    |
    And tokens are set to expire in 1 month
    When I make an API GET request to '/api/v1/client/verify-id-token' as a valid client with:
      | token | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx75 |
    Then the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "expired-id-token",
                "message": "Token expired"
              }
            ]
        }
      """

  Scenario: Client makes GET request to 'verify-id-token' with a token that has already been verified
    Given today is "01-APR-2013"
    And I have a user for the "RamboMD" identity service with:
      | npi         | 1234567890               |
      | firstname   | Carlos                   |
      | lastname    | Casteneda                |
    And the user has the following ois user token:
      | token              | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx60 |
      | verified_timestamp | Tue 01-Apr-2013 01:10:00                                     |
      | createddate        | Tue 01-Apr-2013 00:00:00                                     |
    When I make an API GET request to '/api/v1/client/verify-id-token' as a valid client with:
      | token | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx60 |
    Then the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "verified-id-token",
                "message": "Token previously used for validation"
              }
            ]
        }
      """
