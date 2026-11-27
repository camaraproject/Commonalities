Feature: CAMARA Template Artifact - Test scenarios for sample-implicit-events.yaml

    CAMARA Commonalities: 0.10.0-alpha.1
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

  # This feature file is to be used by CAMARA subproject for operations defined in sample-implicit-events.yaml.
  #
  # References to OAS spec schemas refer to schemas specified in {apiname}.yaml

  # Example Background specification for resource creation that generates implicit events
  Background: Common "{operationId}" setup
    Given an environment at "apiRoot"
    And the resource "/{apiname}/v{version}/{resources}"
    And the request header "Authorization" is set to a valid access token
    And the request header "x-correlator" is non-empty and complies with the OAS schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "#/components/schemas/{createResource}"

############################ Happy Path Scenarios #############################################

  # Test applicable for the related createResource operationId
  @{feature_identifier}_{operationId}_2{xx}_sink_echoed
  Scenario: Sink is returned in the creation "{Resource}" response when event delivery is accepted
    Given the request body includes property "$.sink" with a valid value
    And the request header "Content-Type" is set to "application/json"
    When the request "{operationId}" is sent
    Then the response status code is 2{xx}
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.sink" has same value as the request body property "$.sink"

  # Replace ... in the lastest sentence by any type of applicable validation for the property
  @{feature_identifier}_{operationId}_2{xx}_event_notification
  Scenario: Event is received if the sink was provided and "{Resource}" lifecycle faces an update
    Given an existing resource "{Resource}" was created with valid values for "sink" and "sinkCredential", and with property "$.sinkCredential.credentialType" set to "ACCESSTOKEN"
    And the path parameter "{ResourceId}" is set to the identifier for that "{Resource}"
    And the request header "Content-Type" is set to "application/json"
    When the request "{operationId}" is sent
    Then the response status code is 2{xx}
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And an event is received at the address of the "$.sink" provided for "{Resource}"
    And the event header "Authorization" is set to "Bearer " + the value of the property "$.sinkCredential.accessToken" provided for "{Resource}"
    And the event header "Content-Type" is set to "application/cloudevents+json"
    And the event body complies with the OAS schema at "#/components/schemas/ApiNotificationEvent"
    # Additionally any event body has to comply with some constraints beyond the schema compliance
    And the event body property "$.{property}" is ...

############################ Error Scenarios #############################################

  # Syntax Error scenarios

  @{feature_identifier}_{operationId}_400.07_invalid_sink_credential
  Scenario Outline: Invalid credential
    Given the request body property  "$.sinkCredential.credentialType" is set to "<unsupported_credential_type>"
    And the request header "Content-Type" is set to "application/json"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
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
    And the request header "Content-Type" is set to "application/json"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN" OR "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Service Error scenarios

  # Event notifications capability not supported scenario
  # Only applicable if the API defines the error 422 EVENT_NOTIFICATIONS_NOT_SUPPORTED
  @{feature_identifier}_{operationId}_422.01_event_notifications_not_supported
  Scenario: Event notifications capability not supported
    Given the request body includes property "$.sink" with a valid value
    And the API provider does not implement event notifications delivery for the operation "{operationId}"
    And the request header "Content-Type" is set to "application/json"
    When the request "{operationId}" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 422
    And the response property "$.code" is "EVENT_NOTIFICATIONS_NOT_SUPPORTED"
    And the response property "$.message" contains a user friendly text
