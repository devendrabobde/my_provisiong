@allow-rescue
Feature: System handles errors

  Scenario: Not found pages return 404
    When I visit '/page-not-found'
    Then the HTTP headers should contain:
      | status_code    | 200              |
      | ResponseStatus | error            |
      | ErrorCategory  | request          |
      | ErrorCode      | not-found        |
      | ErrorMessage   | Record not found |
