Feature: CAMARA Template Artifact - Test scenarios for sample-implicit-events.yaml

    CAMARA Commonalities: 0.8.0-rc.2
    Additional Common test scenarios for operations defined in sample-implicit-events.yaml.
    
    Common test scenarios for operations defined in sample-implicit-events.yaml are already defined in sample-service-template.feature. 
    This feature file includes additional scenarios that can be applied to the operations defined in sample-implicit-events.yaml

    NOTES:
    * This is not a complete feature but a collection of scenarios that can be applied with minor
    modifications to test plans. Test plans would have to copy and adapt the scenarios as part of
    their own feature files, along with other scenarios

    * These scenarios assume that other properties not explicitly mentioned in the scenario
    are set by default to a valid value. This can be specified in the feature Background.

    * {feature_identifier} has to be substituted to the value corresponding to the feature file where
    these scenarios are included.

    * {operationId} has to be substituted to the value of operationId for the tested operation

  # This feature file is to be used by CAMARA subproject for operations defined in sample-service.yaml.
  #
  # References to OAS spec schemas refer to schemas specified in {apiname}.yaml

############################ Happy Path Scenarios #############################################

  @{feature_identifier}_{operationId}_xx_event_notification
  Scenario: Event is received if the sink was provided and "<Resource>" lifecycle faces an update
    Given an existing "<Resource>" created by operation "{operationId}" with provided values for "sink" and "sinkCredential"
    And the path parameter "sessionId" is set to the value for that QoS session
    When the request "{operationId}" is sent
    Then the response status code is 2<xx>
    And an event is received at the address of the "$.sink" provided for "{operationId}"
    And the event header "Authorization" is set to "Bearer " + the value of the property "$.sinkCredential.accessToken" provided for "{operationId}"
    And the event header "Content-Type" is set to "application/cloudevents+json"
    And the event body complies with the OAS schema at "#/components/schemas/ApiNotificationEvent"
    # Additionally any event body has to comply with some constraints beyond the schema compliance
    And the event body property "$.<property>" is "<Condition>"

############################ Error Scenarios #############################################

  # Syntax Error scenarios

  @{feature_identifier}_{operationId}_400.07_invalid_sink_credential
  Scenario Outline: Invalid credential
    Given the request body property  "$.sinkCredential.credentialType" is set to "<unsupported_credential_type>"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

    Examples:
      | unsupported_credential_type |
      | PLAIN                       |
      | REFRESHTOKEN                |

  # Only "bearer" is considered in the schema so a generic schema validator may fail and generate a 400 INVALID_ARGUMENT without further distinction,
  # and both could be accepted
  @{feature_identifier}_{operationId}_400.08_sink_credential_invalid_token
  Scenario: Invalid token
    Given the request body property  "$.sinkCredential.accessTokenType" is set to a value other than "bearer"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN" OR "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
