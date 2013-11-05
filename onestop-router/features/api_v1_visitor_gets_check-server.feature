Feature: Visitor gets 'check-server' API
  In order to check the status of the system
  As a visitor
  I can make a request to the 'check-server' API

  Scenario: Visitor makes GET request to 'check-server'
    # See config/server.yml for setting environment specific configuration
    When I make an API GET request to "/api/v1/check-server"
    Then the JSON response should be:
      """
        {
          "service_name": "OneStop Router",
          "server_instance_name": "test",
          "code_version": 1,
          "database_connection": true
        }
      """
