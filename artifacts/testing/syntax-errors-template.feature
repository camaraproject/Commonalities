Feature: CAMARA Template Artifact 400 - Test scenarios for 400 syntax errors

    CAMARA Commonalities: 0.7.0
    
    Common syntax error scenarios for operations.

    NOTES:
    * This is not a complete feature but a collection of scenarios that can be applied with minor
    modifications to test plans. Test plans would have to copy and adapt the scenarios as part of
    their own feature files, along with other scenarios

    * These scenarios assume that other properties not explicitly mentioned in the scenario
    are set by default to a valid value. This can be specified in the feature Background.

    * {feature_identifier} has to be substituted to the value corresponding to the feature file where
    these scenarios are included.

    * {operationId} has to be substituted to the value of operationId for the tested operation

  # This feature file is to be used by CAMARA subproject for Common 400 syntax error scenarios for operations.
  #
  # References to OAS spec schemas refer to schemas specified in {apiname}.yaml

  # Syntax Error scenarios

  @{feature_identifier}_{operationId}_400.1_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "/components/schemas/<requestSchema>"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_400.2_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_400.3_empty_request_body
  # 3-legged scenario only. It happens when request body has at least one required property
  # NOTE: Recommended value for "$.message" (NOT NORMATIVE) is "Missing mandatory parameter(s)"
  Scenario: Empty object as request body
    Given the request body is set to {}
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

@{feature_identifier}_{operationId}_400.4_empty_property
Scenario Outline: Error response for empty property in request body
    Given the request body property "<required_property>" is set to {}
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | required_property |
      | {value}           |

@{feature_identifier}_{operationId}_400.5_missing_required_property
Scenario Outline: Error response for missing required property in request body
    Given the request body property "<required_property>" is not included
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | required_property |
      | {value}           |

  @{feature_identifier}_{operationId}_400.6_invalid_sink_credential
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
  @{feature_identifier}_{operationId}_400.7_sink_credential_invalid_token
  Scenario: Invalid token
    Given the request body property  "$.sinkCredential.accessTokenType" is set to a value other than "bearer"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN" OR "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
