Feature: CAMARA Common Artifact C02 - Test scenarios for phoneNumber errors

    CAMARA Commonalities: 0.6

    Common error scenarios for operations with phoneNumber as input either in the request
    body or implied from the access

    NOTES:
    * This is not a complete feature but a collection of scenarios that can be applied with minor
      modifications to test plans. Test plans would have to copy and adapt the scenarios as part of
      their own feature files, along with other scenarios.

    * These scenarios assume that other properties not explicitly mentioned in the scenario
      are set by default to a valid value. This can be specified in the feature Background.

    * {feature_identifier} has to be substituted to the value corresponding to the feature file where
    these scenarios are included.

    * {operationId} has to be substituted to the value of operationId for the tested operation

    * {path_to_phoneNumber} has to be substituted to the JSON path of the phoneNumber property in the body request, typically
    "$.phoneNumber" or "$.config.subscriptionDetail.phoneNumber" for Subscription APIs

  # This feature file is to be used by CAMARA subproject when Common error scenarios for operations with phoneNumber as input either in the request body or implied from the access
  #
  # References to OAS spec schemas refer to schemas specified in {apiname}.yaml

  # Error scenarios for management of input parameter phoneNumber

  @{feature_identifier}_C02.01_phone_number_not_schema_compliant
  Scenario: Phone number value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And the request body property "{path_to_phoneNumber}" does not comply with the OAS schema at "/components/schemas/PhoneNumber"
    When the request "{operationId}" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    @{feature_identifier}_C02.02_phone_number_not_found
    Scenario: Phone number not found
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And the request body property "{path_to_phoneNumber}" is compliant with the schema but does not identify a valid phone number
    When the request "{operationId}" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_C02.03_unnecessary_phone_number
  Scenario: Phone number not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a phone number
    And  the request body property "{path_to_phoneNumber}" is set to a valid phone number
    When the request "{operationId}" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @{feature_identifier}_C02.04_missing_phone_number
  Scenario: Phone number not included and cannot be deducted from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And the request body property "{path_to_phoneNumber}" is not included
    When the request "{operationId}" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  # When the service is only offered to certain type of subscriptions, e.g. IoT, , B2C, etc
  @{feature_identifier}_C02.05_phone_number_not_supported
  Scenario: Service not available for the phone number
    Given that the service is not available for all phone numbers commercialized by the operator
    And a valid phone number, identified by the token or provided in the request body, for which the service is not applicable
    When the request "{operationId}" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text
