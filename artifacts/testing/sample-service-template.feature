Feature: CAMARA Template Artifact - Test scenarios for sample-service.yaml

    CAMARA Commonalities: 0.8.0-rc.2
    Common test scenarios for operations defined in sample-service.yaml.

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

  Background: Common "<operationId>" setup
    Given an environment at "apiRoot"
    # Clause for createResource and listResources operations
    And the resource "/{apiname}/v{version}/{resources}"
    # Clause for getResource and deleteResource operations
    And the resource "/{apiname}/v{version}/{resources}/{resourceId}"
    # Clause only for createResource, listResources and getResource operations
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    # Properties not explicitly overwritten in the Scenarios can take any values compliant with the schema, clause only for createResource (i.e. only for POST/PUT operations in general)
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/<createResource>"
    # Clause for getResource and deleteResource operations
    And the path parameter "<ResourceId>" is set by default to a existing value

############################ Happy Path Scenarios #############################################
  
  # createResource MUST be replaced by applicable operationId for the tested operation
  # schema names MUST be replaced by applicable values for the tested operation
  @{feature_identifier}_{createResource}_01_generic_success_scenario
  Scenario Outline: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    # Several clauses for request body property may apply depending on the operation
    And the request body property "$.{requestProperty}" is set to a valid {placeholder_suitable_text}
    And the request body is compliant with the schema at "/components/schemas/<createResource>"
    When the request "<createResource>" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/<Resource>"
    # Additionally, in case any success response has to comply with some constraints beyond the schema compliance
    And the response property "<property>" matches the rule: <condition>

    Examples:
      | property                 | condition                 |
      | $.xxx                    | yyy                       |

  # listResources MUST be replaced by applicable operationId for the tested operation
  # schema names MUST be replaced by applicable values for the tested operation
  @{feature_identifier}_{listResources}_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given at least an existing "<Resource>" created by operation "{operationId}"
    When the request "<listResources>" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body is an array whose items comply with the OAS schema at "/components/schemas/<Resource>"

  @{feature_identifier}_{listResources}_02_empty_response
  Scenario: No existing {Resources}
    Given no {Resources} have been created by operation "{operationId}"
    When the request "<listResources>" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an empty array "[]"

  # getResource MUST be replaced by applicable operationId for the tested operation
  # schema names MUST be replaced by applicable values for the tested operation
  @{feature_identifier}_{getResource}_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given an existing "<Resource>" created by operation "{operationId}"
    And the path parameter "<ResourceId>" is set to the value for that "<Resource>"
    When the request "<getResource>" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/<Resource>"

  # deleteResource MUST be replaced by applicable operationId for the tested operation
  @{feature_identifier}_{deleteResource}_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    Given an existing "<Resource>" created by operation "{operationId}"
    And the path parameter "<ResourceId>" is set to the value for that "<Resource>"
    When the request "<deleteResource>" is sent
    Then the response status code is 204
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"

############################ Error Scenarios #############################################

  # Syntax Error scenarios

  @{feature_identifier}_{operationId}_400.01_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "/components/schemas/<requestSchema>"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_400.03_empty_request_body
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

@{feature_identifier}_{operationId}_400.04_empty_property
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

@{feature_identifier}_{operationId}_400.05_missing_required_property
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

  @{feature_identifier}_{operationId}_400.06_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  # Service Error scenarios

  ## Authentication/Authorization errors

    # Generic 401 errors

  @{feature_identifier}_{operationId}_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "{operationId}" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "{operationId}" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "{operationId}" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Generic 403 errors

  @{feature_identifier}_{operationId}_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "<scope>"
    When the request "{operationId}" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_403.2_api_client_token_mismatch
  Scenario: QoS session not created by the API client given in the access token
    # To test this, a token has to be obtained for a different client
    Given the header "Authorization" is set to a valid access token emitted to an API client which did not have rights to access/manage the "<Resource>"
    When the request "{operationId}" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Generic 404 Errors

  @{feature_identifier}_{operationId}_404.01_not_found
  Scenario: non-existing "<ResourceId>"
    Given the path parameter "<ResourceId>" is set to a random UUID
    When the request "{operationId}" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 409 Errors

  # This scenario applies to operations that create/manage a resource with a unique property (e.g. name) and the service does not allow multiple resources with the same value for that property, even if they have different identifiers. If the service allows multiple resources with the same value for that property, this scenario would not apply.
  @{feature_identifier}_{operationId}_409.01_duplicated_resource
  Scenario: Conflict due to existing "<Resource>"
    Given a "<Resource>" already exists with the same unique property as the one in the request body
    # Additional clauses may exist according to API nature
    And the request body property "$.<requestProperty>" is set to a value already used in another successful "<Resource>" request
    When the request "{operationId}" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "ALREADY_EXISTS"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_409.02_request_aborted
  Scenario: Conflict due to "<Resource>" being modified
    Given a "<Resource>" is being modified by another request and the service does not allow concurrent modifications for the same resource
    # Additional clauses may exist according to API nature
    And the request body property "$.<requestProperty>" is set to a value already used in another successful "<Resource>" request
    When the request "{operationId}" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "ABORTED"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_{operationId}_409.03_incompatible_state
  Scenario: Conflict due to "<Resource>" (target or referenced) is in incompatible state for the requested operation
    Given a "<Resource>" is not in an available state for being managed
    # Additional clauses may exist according to API nature
    And the request body property "$.<requestProperty>" is set to a value already used in another successful "<Resource>" request
    When the request "{operationId}" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "INCOMPATIBLE_STATE"
    And the response property "$.message" contains a user friendly text

  # Generic 429 scenarios

  @{feature_identifier}_{operationId}_429.01_Too_Many_Requests
  #To test this scenario environment has to be configured to reject requests reaching the threshold limit set.
  Scenario: Request is rejected due to threshold policy
    Given a valid request for "{operationId}"
    And the header "Authorization" is set to a valid access token
    And the threshold of requests has been reached
    When the request "{operationId}" is sent
    Then the response status code is 429
    And the response property "$.status" is 429
    And the response property "$.code" is "TOO_MANY_REQUESTS"
    And the response property "$.message" contains a user friendly text
