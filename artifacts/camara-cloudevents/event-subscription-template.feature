@<xxx> 
Feature: Camara Template Subscriptions API, v{version here} - Operations on subscriptions

  # This feature file is to be used by CAMARA sub projet when an event subscription ressource is provided.
  # We designed as <xxx> the subscription resource prefix.
  # We designed as <x> the event version.

  #
  # If the subscription leverages 'device' object the following indication must be present:
  #    Implementation indications:
  #      * List of device identifier types which are not supported, among: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  #
  # Testing assets:
  #        A sink-url identified as "callbackUrl", which receives notifications
  #        + Add here the specific testing asset(s) required to test the API
  #
  # References to OAS spec schemas refer to schemas specifies in <xxx>-subscriptions.yaml
  #
  # IMPORTANT: This file must be completed with test cases specific to the subscription type managed by the API.

  Background: Common <xxx> Subscriptions setup
    Given the resource "{apiroot}/<xxx>-subscriptions/vwip/" as <xxx> base-url
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value

############################ Happy Path Scenarios #############################################

# Note: Depending on the API managed personal data specific scenario update may be require to specify use of 2-legs or 3-legs access token.

  @<xxx>_subscriptions_01_Create_<xxx>_subscription_sync

  Scenario:  Create <xxx> subscription (sync creation)
   # Some implementations may only support asynchronous subscription creation
    Given that subscriptions are created synchronously
    And a valid subscription request body 
    When the request "createSubscription" is sent 
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @<xxx>_subscriptions_02_Create_<xxx>_subscription_async
  Scenario:  Create <xxx> subscription (async creation)
   # Some implementations may only support synchronous subscription creation
    Given that subscriptions are created asynchronously
    And a valid subscription request body
    When the request "createSubscription" is sent
    Then the response code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @<xxx>_subscriptions_03_subscription_creation_event_validation
  Scenario: Receive notification for subscription-started event on creation
    Given a valid subscription request body 
    When the request "createSubscription" is sent
    Then the response code is 201 or 202	
    Then event notification "subscription-started" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/SubscriptionStarted"

    And type="org.camaraproject.<xxx>-subscriptions.v0.subscription-started"
    And the response property "$.initiationReason" is "SUBSCRIPTION_CREATED"

  @<xxx>_subscriptions_04_Operation_to_retrieve_list_of_subscriptions_when_no_records
  Scenario: Get a list of <xxx> subscriptions when no subscriptions available
    Given a client without <xxx> subscriptions created
    When the request "retrieve<xxx>SubscriptionList" is sent 
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an empty array

  @<xxx>_subscriptions_05_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions
    Given a client with <xxx> subscriptions created
    When the request "retrieve<xxx>SubscriptionList" is sent 
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body has an array of items and each item complies with the OAS schema at "/components/schemas/Subscription"

  @<xxx>_subscriptions_06_Operation_to_retrieve_subscription_based_on_an_existing_subscription-id
  Scenario: Get a subscription based on existing subscription-id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "retrieve<xxx>Subscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  @<xxx>_subscriptions_07_Operation_to_delete_subscription_based_on_an_existing_subscription-id
  Scenario: Delete a subscription based on existing subscription-id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "delete<xxx>Subscription" is sent
    Then the response code is 202 or 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And if the response property $.status is 204 then the response body is not available
    And if the response property $.status is 202 then the response body complies with the OAS schema at "/components/schemas/SubscriptionAsync"	
	
  @<xxx>_subscriptions_08_subscription_ends_on_expiry
  Scenario: Receive notification for subscription-ended event on expiry
    Given a valid <xxx> subscription request body 
    And the request body property "$.subscriptionExpireTime" is set to a value in the near future
    When the request "createSubscription" is sent
    Then the response code is 201 
    Then the subscription is expired
    Then event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnds"
    And type="org.camaraproject.<xxx>-subscriptions.v0.subscription-ended"
    And the response property "$.terminationReason" is "SUBSCRIPTION_EXPIRED"
    
  @<xxx>_subscriptions_09_subscription_ends_on_max_events
  Scenario: Receive notification for subscription-ended event on max events reached
    Given a valid <xxx> subscription request body
    And the request body property "$.subscriptionMaxEvents" is set to 1
    When the request "createSubscription" is sent
    Then the response code is 201
    Then the event subscribed occurs
    Then event notification "<event-type>" is received on callback-url
    Then event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnds"
    And type="org.camaraproject.<xxx>-subscriptions.v0.subscription-ended"And the response property "$.terminationReason" is "MAX_EVENTS_REACHED"
		
  @<xxx>_subscriptions_10_subscription_delete_event_validation
  Scenario: Receive notification for subscription-ended event on deletion
    Given a valid subscription request body 
    When the request "createSubscription" is sent
    Then the response code is 201 
    And path parameter "subscriptionId" is set to the identifier of an existing subscription created 
    When the request "delete<xxx>Subscription" is sent
    Then the response code is 202 or 204	
    Then event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "##/components/schemas/EventSubscriptionEnds"
    And type="org.camaraproject.<xxx>-subscriptions.v0.subscription-ended"
    And the response property "$.terminationReason" is "SUBSCRIPTION_DELETED"
	
########################### Error response scenarios ############################################

########################### Subscription creation scenarios #####################################

  @<xxx>_subscriptions_20_create_<xxx>_subscription_with_invalid_parameter
  Scenario:  Create <xxx> subscription with invalid parameter
    Given the request body is not compliant with the schema "/components/schemas/SubscriptionRequest"
    When the  request "createSubscription" is sent 
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_21_creation_of_subscription_with_expiry_time_in_past
  Scenario: Expiry time in past
    Given a valid <xxx> subscription request body 
    And request body property "$.subscriptionExpireTime" in past
    When the request "createSubscription" is sent 
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
	  	
  @<xxx>_subscription_22_creation_with_invalid_eventType
  Scenario: Subscription creation with invalid event type
    Given a valid <xxx> subscription request body 
    And the request body property "$.types" is set to invalid value  
    When the request "createSubscription" is sent
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
    
  @<xxx>_subscription_23_invalid_protocol
  Scenario: Subscription creation with invalid protocol
    Given a valid <xxx> subscription request body 
    When the request "createSubscription" is sent
    And the request property "$.protocol" is not set to "HTTP"
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_PROTOCOL"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscription_24_invalid_credential
  Scenario: Subscription creation with invalid credential
    Given a valid <xxx> subscription request body 
    When the request "createSubscription" is sent
    And the request property "$.protocol" is set to "HTTP"
    And the request property "$.sinkCredential.credentialType" is not set to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request property "$.sinkCredential.accessToken" is valued with a valid value
    And the request property "$.sinkCredential.accessTokenExpiresUtc" is valued with a valid value
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscription_25_invalid_token
  Scenario: Subscription creation with invalid token
    Given a valid <xxx> subscription request body
    When the request "createSubscription" is sent
    And  the request property "$.protocol" is set to "HTTP"
    And the request property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is not set to "bearer"
    And the request property "$.sinkCredential.accessToken" is valued with a valid value
    And the request property "$.sinkCredential.accessTokenExpiresUtc" is valued with a valid value
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN" or "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_26_no_authorization_header_for_create_subscription
  Scenario: No Authorization header for create subscription
    Given a valid <xxx> subscription request body and header "Authorization" is not set to 
    When the request "createSubscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_27_expired_access_token_for_create_subscription
  Scenario: Expired access token for create subscription
    Given a valid <xxx> subscription request body and header "Authorization" is expired
    When the request "createSubscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_28_invalid_access_token_for_create_subscription
  Scenario: Invalid access token for create subscription
    Given a valid <xxx> subscription request body 
    And header "Authorization" set to an invalid access token
    When the request "createSubscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

########################### Subscription retrieval scenarios #####################################

  @<xxx>_subscriptions_29_no_authorization_header_for_get_subscription
  Scenario: No Authorization header for get subscription
    Given header "Authorization" is not set to valid token
    And path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "retrieve<xxx>Subscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_30_expired_access_token_for_get_subscription
  Scenario: Expired access token for get subscription
    Given the header "Authorization" is set to expired token
    When the request "retrieve<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
    
  @<xxx>_subscriptions_31_invalid_access_token_for_get_subscription
  Scenario: Invalid access token for get subscription
    Given the header "Authorization" set to an invalid access token
    When the request "retrieve<xxx>Subscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_32_get_unknown_<xxx>_subscription_for_a_device
  Scenario:  Get method for <xxx> subscription with subscription-id unknown to the system  
    Given the path parameter "subscriptionId" is set to the value unknown to system
    When the request "retrieve<xxx>Subscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

########################### Subscription deletion scenarios #####################################

  @<xxx>_subscriptions_33_no_authorization_header_for_delete_subscription
  Scenario: No Authorization header for delete subscription
    Given header "Authorization" is set without a token
    When the request "delete<xxx>Subscription" is sent 
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_34_expired_access_token_for_delete_subscription
  Scenario: Expired access token for delete subscription
    Given header "Authorization" is set with an expired token
    When the request "delete<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_35_invalid_access_token_for_delete_subscription
  Scenario: Invalid access token for delete subscription
    Given header "Authorization" set to an invalid access token
    When the request "delete<xxx>Subscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_36_delete_invalid_<xxx>_subscription
  Scenario:  Delete <xxx> subscription with subscription-id unknown to the system
    Given the path parameter "subscriptionId" is set to the value unknown to system
    When the request "delete<xxx>Subscription" is sent
    Then the response code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

########Specific Subscription error scenarios when Device object is  used ################
### These scenarios must be present if the device object is used in the subscription  ####

  @<xxx>_subscriptions_40_create_with_identifier_mismatch
  Scenario: Create subscription with identifier mismatch
    Given the request body includes inconsistent identifiers (like a phone number and an IP not corresponding to same device)
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "IDENTIFIER_MISMATCH"
    And the response property "$.message" contains "Identifiers are not consistent."

  @<xxx>_subscriptions_41_create_with_service_not_applicable
  Scenario: Create subscription for a device not supported by the service
    Given the request body includes a device identifier not applicable for this service
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains "Service is not available for the provided device identifier."

  @<xxx>_subscriptions_42_create_with_unnecessary_identifier
  Scenario: Create subscription with an unnecessary identifier
    Given the request body explicitly includes a device identifier when it is not required as deductible from the access token
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains "Device is already identified by the access token."

  @<xxx>_subscriptions_43_create_with_unsupported_identifier
  Scenario: Create subscription with an unsupported identifier
    Given the request body includes an identifier type not supported by the implementation
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains "The identifier provided is not supported."

  @<xxx>_subscriptions_44_missing_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

