Feature: Client authentication
  In order to authenticate as a OneStop client
  As a client
  I can login to the OneStop system API

  Background:
    Given the following ois client exists:
      | client_name     | carlos.casteneda                                   |
      | client_password | 12345678911234567892123456789312345678941234567895 |

  Scenario: Client makes a valid request
    When I make a client request with the following headers:
      | ClientId       | carlos.casteneda      |
      | ClientPassword | 12345678911234567892123456789312345678941234567895 |
    Then the HTTP headers should contain:
      | status_code    | 200     |
      | ResponseStatus | success |
      | ErrorCategory  | request |
      | ErrorCode      |         |
      | ErrorMessage   |         |

  Scenario: Disabled client cannot login
    Given the client "carlos.casteneda" is disabled
    When I make a client request with the following headers:
      | ClientId       | carlos.casteneda                                   |
      | ClientPassword | 12345678911234567892123456789312345678941234567895 |
    Then the HTTP headers should contain:
      | status_code    | 200                         |
      | ResponseStatus | error                       |
      | ErrorCategory  | request                     |
      | ErrorCode      | unauthorized                |
      | ErrorMessage   | Unauthorized Client account |

  Scenario Outline: Client makes a request using invalid credentials
    When I make a client request with the following headers:
      | ClientId       | <client_name>     |
      | ClientPassword | <client_password> |
    Then the HTTP headers should contain:
      | status_code    | 200                         |
      | ResponseStatus | error                       |
      | ErrorCategory  | request                     |
      | ErrorCode      | unauthorized                |
      | ErrorMessage   | Unauthorized Client account |

    Examples:
      | client_name      | client_password                                    |
      | jimmy.braccioni  | 12345678911234567892123456789312345678941234567895 |
      | carlos.casteneda | wrong-password                                     |

  @wip
  Scenario: Client makes a request and receives a system error
    When I make a client request with the following headers:
      | ClientId       | carlos.casteneda                                   |
      | ClientPassword | 12345678911234567892123456789312345678941234567895 |
    Then the HTTP headers should contain:
      | status_code     | 500          |
      | response_status | error        |
      | error_category  | system       |
      | error_code      | system-error |
      | error_message   | System Error |
