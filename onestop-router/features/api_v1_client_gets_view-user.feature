Feature: Client gets 'view-user' API
  In order to provide a client with full user details
  As a client
  I can make a get request to the 'view-user' API

  Background:
    Given the following organization exists:
      | organization_name  | Reenhanced LLC        |
      | address1           | 312 West Broad Street |
      | address2           | First Floor           |
      | city               | Quakertown            |
      | state_code         | PA                    |
      | postal_code        | 18951                 |
      | country_code       | USA                   |
      | contact_first_name | Nicholas              |
      | contact_last_name  | Hance                 |
      | contact_phone      | 1 (866) 237-6836      |
      | contact_fax        | (610) 886-3311        |
      | contact_email      | nhance@reenhanced.com |
      | organization_npi   | 1234567890            |
    Given the following ois exists:
      | id               | 9082a027-cddf-416d-86a6-09f8e27ed53f |
      | ois_name         | RamboMD                              |
      | enrollment_url   | http://rambomd.com/signup            |
      | idp_level        | 1                                    |
    And the "RamboMD" identity service belongs to the "Reenhanced LLC" organization
    And I have a user for the "RamboMD" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |

  Scenario: Client makes GET request to 'view-user'
    Given the following ois exists:
      | ois_name         | Facebook                             |
      | enrollment_url   | http://facebook.com/signup           |
      | idp_level        | 1                                    |
    And the "Facebook" identity service belongs to the "Reenhanced LLC" organization
    And I have a user for the "Facebook" identity service with:
      | npi        | 1234567890 |
      | first_name | Carlos     |
      | last_name  | Casteneda  |
    When I make an API GET request to '/api/v1/client/view-user' as a valid client with:
      | npi | 1234567890 |
    And the JSON response should be:
      """
        [
          {
            "first_name": "Carlos",
            "last_name":  "Casteneda",
            "npi":        "1234567890",
            "ois_params": {
              "city":             "Quakertown",
              "country":          "USA",
              "email_address":    "nhance@reenhanced.com",
              "fax_number":       "(610) 886-3311",
              "phone_number":     "1 (866) 237-6836",
              "postal_code":      "18951",
              "state_code":       "PA",
              "street_address_1": "312 West Broad Street",
              "street_address_2": "First Floor"
            },
            "ois_slug": "rambomd"
          },
          {
            "first_name":  "Carlos",
            "last_name":   "Casteneda",
            "npi":         "1234567890",
            "ois_params": {
              "city":             "Quakertown",
              "country":          "USA",
              "email_address":    "nhance@reenhanced.com",
              "fax_number":       "(610) 886-3311",
              "phone_number":     "1 (866) 237-6836",
              "postal_code":      "18951",
              "state_code":       "PA",
              "street_address_1": "312 West Broad Street",
              "street_address_2": "First Floor"
            },
            "ois_slug": "facebook"
          }
        ]
      """

  Scenario Outline: Client makes GET request to 'view-user' with an ois_id or ois_slug
    When I make an API GET request to '/api/v1/client/view-user' as a valid client with:
      | npi    | <npi>            |
      | ois_id | <ois_id_or_slug> |
    And the JSON response should be:
      """
        [
          {
            "first_name": "Carlos",
            "last_name":  "Casteneda",
            "npi":        "1234567890",
            "ois_params": {
              "city":             "Quakertown",
              "country":          "USA",
              "email_address":    "nhance@reenhanced.com",
              "fax_number":       "(610) 886-3311",
              "phone_number":     "1 (866) 237-6836",
              "postal_code":      "18951",
              "state_code":       "PA",
              "street_address_1": "312 West Broad Street",
              "street_address_2": "First Floor"
            },
            "ois_slug": "rambomd"
          }
        ]
      """

    Examples:
      | npi        | ois_id_or_slug                       |
      | 1234567890 | 9082a027-cddf-416d-86a6-09f8e27ed53f |
      | 1234567890 | rambomd                              |

  Scenario: Client makes GET request to 'view-user' without an NPI
    When I make an API GET request to '/api/v1/client/view-user' as a valid client
    Then the JSON response should be:
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
