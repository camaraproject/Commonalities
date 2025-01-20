Feature: CAMARA Common Artifact C01 - Test scenarios for device errors

    Common error scenarios for POST operations with device as input either in the request
    body or implied from the access.

    NOTES: 
    * This is not a complete feature but a collection of scenarios that can be applied with minor
    modifications to test plans. Test plans would have to copy and adapt the scenarios as part of
    their own feature files, along with other scenarios

    * These scenarios assume that other properties not explicitly mentioned in the scenario
    are set by default to a valid value. This can be specified in the feature Background.
    
    * {{feature_identifier}} has to be substituted to the value corresponding to the feature file where
    these scenarios are included.

    # Error scenarios for management of input parameter device

    @{{feature_identifier}}_C01.01_device_empty
    Scenario: The device value is an empty object
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "$.device" is set to: {}
        When the HTTP "POST" request is sent
        Then the response status code is 400
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text


    @{{feature_identifier}}_C01.02_device_identifiers_not_schema_compliant
    Scenario Outline: Some device identifier value does not comply with the schema
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
        When the HTTP "POST" request is sent
        Then the response status code is 400
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text
        
        Examples:
            | device_identifier          | oas_spec_schema                             |
            | $.device.phoneNumber       | /components/schemas/PhoneNumber             |
            | $.device.ipv4Address       | /components/schemas/DeviceIpv4Addr          |
            | $.device.ipv6Address       | /components/schemas/DeviceIpv6Address       |
            | $.device.networkIdentifier | /components/schemas/NetworkAccessIdentifier |

  
    # This scenario may happen e.g. with 2-legged access tokens, which do not identify a single device.
    @{{feature_identifier}}_C01.03_device_not_found
    Scenario: Some identifier cannot be matched to a device
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "$.device" is compliant with the schema but does not identify a valid device
        When the HTTP "POST" request is sent
        Then the response status code is 404
        And the response property "$.status" is 404
        And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
        And the response property "$.message" contains a user friendly text


    @{{feature_identifier}}_C02.04_unnecessary_device
    Scenario: Device not to be included when it can be deduced from the access token
        Given the header "Authorization" is set to a valid access token identifying a device

        And the request body property "$.device" is set to a valid device
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
        And the response property "$.message" contains a user-friendly text


    @{{feature_identifier}}_C01.05_missing_device
    Scenario: Device not included and cannot be deduced from the access token
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "$.device" is not included
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "MISSING_IDENTIFIER"
        And the response property "$.message" contains a user-friendly text


    @{{feature_identifier}}_C01.06_unsupported_device
    Scenario: None of the provided device identifiers is supported by the implementation
        Given that some types of device identifiers are not supported by the implementation
        And the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "$.device" only includes device identifiers not supported by the implementation
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
        And the response property "$.message" contains a user-friendly text


    # When the service is only offered to certain types of devices or subscriptions, e.g. IoT, B2C, etc.
    @{{feature_identifier}}_C01.07_device_not_supported
    Scenario: Service not available for the device
        Given that the service is not available for all devices commercialized by the operator
        And a valid device, identified by the token or provided in the request body, for which the service is not applicable
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
        And the response property "$.message" contains a user-friendly text


    # Several identifiers provided but they do not identify the same device
    # This scenario may happen with 2-legged access tokens, which do not identify a device
    @{{feature_identifier}}_C01.08_device_identifiers_mismatch
    Scenario: Device identifiers mismatch
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And at least 2 types of device identifiers are supported by the implementation
        And the request body property "$.device" includes several identifiers, each of them identifying a valid but different device
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "IDENTIFIER_MISMATCH"
        And the response property "$.message" contains a user friendly text
