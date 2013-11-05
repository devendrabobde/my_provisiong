Feature: Client gets 'get-private-label' API
  In order to check private label information
  As a client
  I can make a request to the 'get-private-label' API

  Scenario: Client makes GET request to 'get-private-label'
    Given today is always "21 Feb 2013" at "1:00:00pm"
    And the following ois client preference exists:
      | client_name      | OneStop Rambo               |
      | preference_name  | Rambo M.D.                  |
      | faq_url          | http://rambomd.com/faq      |
      | help_url         | http://rambomd.com/help     |
      | logo_url         | http://rambomd.com/logo.png |
    And I'm using a client account associated with the client preference named "OneStop Rambo"
    When I make an API GET request to '/api/v1/client/get-private-label' as a valid client
    Then the JSON response should be:
      """
        {
          "client_name":      "OneStop Rambo",
          "created_date":     "2013-02-21T00:00:00Z",
          "faq_url":          "http://rambomd.com/faq",
          "help_url":         "http://rambomd.com/help",
          "logo_url":         "http://rambomd.com/logo.png",
          "preference_name":  "Rambo M.D.",
          "last_update_date": "2013-02-21T00:00:00Z",
          "slug":             "rambo-m-d"
        }
      """
