Feature: OIS authentication
  In order to authenticate as a OneStop identity service (OIS)
  As an OIS
  I can login to the OneStop system API

  Background:
    Given the following ois exists:
      | ois_name     | DFID                                               |
      | ois_password | 12345678911234567892123456789312345678941234567895 |

  Scenario: OIS makes a valid request
    When I make an ois save-user request with the following headers:
      | OisId       | dfid                                               |
      | OisPassword | 12345678911234567892123456789312345678941234567895 |
    Then the HTTP headers should contain:
      | status_code    | 200     |
      | ResponseStatus | success |
      | ErrorCategory  | request |
      | ErrorCode      |         |
      | ErrorMessage   |         |

  Scenario Outline: OIS makes a request using invalid credentials
    When I make an ois save-user request with the following headers:
      | OisId       | <ois_id>       |
      | OisPassword | <ois_password> |
    Then the HTTP headers should contain:
      | status_code    | 200              |
      | ResponseStatus | error            |
      | ErrorCategory  | request          |
      | ErrorCode      | unauthorized     |
      | ErrorMessage   | Unauthorized OIS |

    Examples:
      | ois_id | ois_password                                       |
      | 0      | 12345678911234567892123456789312345678941234567895 |
      | DFID   | wrong-password                                     |

  Scenario: Disabled client cannot login
    Given the ois "DFID" is disabled
    When I make an ois save-user request with the following headers:
      | OisId       | dfid                                               |
      | OisPassword | 12345678911234567892123456789312345678941234567895 |
    Then the HTTP headers should contain:
      | status_code    | 200              |
      | ResponseStatus | error            |
      | ErrorCategory  | request          |
      | ErrorCode      | unauthorized     |
      | ErrorMessage   | Unauthorized OIS |
