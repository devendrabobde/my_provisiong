Feature: OIS posts 'create-id-token' API
  In order to generate an ois user token for an OIS
  As an OIS
  I can make a post request to the 'create-id-token' API

  Background:
    Given the following ois exists:
      | ois_name  | RamboMD |
      | idp_level | 1       |
    And I have a user for the "RamboMD" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |

  Scenario: OIS makes POST request to 'create-id-token'
    When I make an API POST request to '/api/v1/ois/create-id-token' as a valid OIS with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
      | idp_level  | 1          |
    Then a ois user token should have been created for the user with NPI "1234567890"
    And the JSON response should contain the generated ois user token

  Scenario: OIS makes POST request to with missing data
    When I make an API POST request to '/api/v1/ois/create-id-token' as a valid OIS
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

  @allow-rescue
  Scenario Outline: OIS makes POST request to 'create-id-token' with invalid user data
    When I make an API POST request to '/api/v1/ois/create-id-token' as a valid OIS with:
      | npi        | <npi>        |
      | first_name | <first_name> |
      | last_name  | <last_name>  |
      | idp_level  | <idp_level>  |
    Then the JSON response should be:
      """
        {
          "errors":
            [
              {
                "code": "<error_code>",
                "message": "<error_message>"
              }
            ]
        }
      """

    Examples:
      | npi        | first_name | last_name | idp_level | error_code        | error_message            |
      | 1231231230 | Carlos     | Casteneda | 1         | not-found         | User not found           |
      | 1234567890 | Greatest   | Casteneda | 1         | npi-name-mismatch | NPI Name Mismatch        |
      | 1234567890 | Carlos     | Ever      | 1         | npi-name-mismatch | NPI Name Mismatch        |
      | 1234567890 | Carlos     | Casteneda | 4         | invalid-id-token  | IDP level does not match |
