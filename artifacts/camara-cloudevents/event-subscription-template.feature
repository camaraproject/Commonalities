@<xxx>
Feature: Camara Template Subscriptions API, v{version here} - Operations on subscriptions

  # This feature file is to be used by CAMARA subproject when an event subscription resource is provided.
  # We use <xxx> as the subscription resource prefix.
  # We use <x> as the event version.
  #
  # If the subscription leverages the 'device' object the following indication must be present:
  #    Implementation indications:
  #      * List of device identifier types which are not supported, such as: phoneNumber, networkAccessIdentifier, ipv4Address, ipv6Address
  #
  # Testing assets:
  #        A sink-url identified as "callbackUrl", which receives notifications
  #        + Add here the specific testing asset(s) required to test the API
  #
  # References to OAS spec schemas refer to schemas specified in <xxx>-subscriptions.yaml
  # References to schemas starting with the # symbol are JSON Pointers from the root of the OAS document: <xxx>-subscriptions.yaml, Schema names are aligned with the event-subscription-template.yaml artifact.
  #
  # IMPORTANT:
  # 1/ This file must be completed with the test cases specific to the subscription type managed by the API.
  # 2/ Specific Subscription error scenarios when the Device object is used must be added. These scenarios are available in CAMARA Github.   ################
  #    source: Commonalities/artifacts/testing

  Background: Common <xxx> Subscriptions setup
    Given the resource "{apiroot}/<xxx>-subscriptions/vwip/" as <xxx> base-url
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

############################ Happy Path Scenarios #############################################

# Note: Depending on the API managed personal data specific scenario update may be require to specify use of 2-legs or 3-legs access token.

  @<xxx>_subscriptions_01_Create_<xxx>_subscription_sync
  Scenario: Create <xxx> subscription (sync creation)
   # Some implementations may only support asynchronous subscription creation
    Given that subscriptions are created synchronously
    And a valid subscription request body
    When the request "create<xxx>Subscription" is sent
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  @<xxx>_subscriptions_02_Create_<xxx>_subscription_async
  Scenario:  Create <xxx> subscription (async creation)
   # Some implementations may only support synchronous subscription creation
    Given that subscriptions are created asynchronously
    And a valid subscription request body
    When the request "create<xxx>Subscription" is sent
    Then the response code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @<xxx>_subscriptions_03_subscription_creation_event_validation
  Scenario: Receive notification for subscription-started event on creation
    Given a valid subscription request body
    When the request "create<xxx>Subscription" is sent
    Then the response code is 201 or 202
    And event notification "subscription-started" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionStarted"
    And type="org.camaraproject.<xxx>-subscriptions.v<x>.subscription-started"
    And the response property "$.initiationReason" is "SUBSCRIPTION_CREATED"

  @<xxx>_subscriptions_04_Operation_to_retrieve_list_of_subscriptions_when_no_records
  Scenario: Get a list of <xxx> subscriptions when no subscriptions available
    Given a client without <xxx> subscriptions created
    When the request "retrieve<xxx>SubscriptionList" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is an empty array

  @<xxx>_subscriptions_05_Operation_to_retrieve_list_of_subscriptions
  Scenario: Get a list of subscriptions
    Given a client with <xxx> subscriptions created
    When the request "retrieve<xxx>SubscriptionList" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body has an array of items and each item complies with the OAS schema at "#/components/schemas/Subscription"

  @<xxx>_subscriptions_06_Operation_to_retrieve_subscription_based_on_an_existing_subscription-id
  Scenario: Get a subscription based on existing subscription-id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "retrieve<xxx>Subscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  @<xxx>_subscriptions_07_Operation_to_delete_subscription_based_on_an_existing_subscription-id
  Scenario: Delete a subscription based on existing subscription-id.
    Given the path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "delete<xxx>Subscription" is sent
    Then the response code is 202 or 204
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And if the response property "$.status" is 204 then the response body is not available
    And if the response property "$.status" is 202 then the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @<xxx>_subscriptions_08_subscription_ends_on_expiry
  Scenario: Receive notification for subscription-ended event on expiry
    Given an existing <xxx> subscription with some value for the property "expiresAt" in the near future
    When the subscription is expired
    Then the event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.<xxx>-subscriptions.v<x>.subscription-ended"
    And the response property "$.terminationReason" is "SUBSCRIPTION_EXPIRED"

  @<xxx>_subscriptions_09_subscription_ends_on_max_events
  Scenario: Receive notification for subscription-ended event on max events reached
    Given an existing <xxx> subscription with the property "config.subscriptionMaxEvents" set to 1
    When the event subscribed occurs
    Then event notification "<event-type>" is received on callback-url
    And event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.<xxx>-subscriptions.v<x>.subscription-ended"
    And the response property "$.terminationReason" is "MAX_EVENTS_REACHED"

  @<xxx>_subscriptions_10_subscription_delete_event_validation
  Scenario: Receive notification for subscription-ended event on deletion
    Given the path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "delete<xxx>Subscription" is sent
    Then the response code is 202 or 204
    And event notification "subscription-ended" is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And type="org.camaraproject.<xxx>-subscriptions.v<x>.subscription-ended"
    And the response property "$.terminationReason" is "SUBSCRIPTION_DELETED"

######################### Scenario in case initialEvent is managed ##############################

@<xxx>_subscriptions_11_subscription_creation_initial_event
  Scenario: Receive initial event notification on creation
    Given the API supports initial events to be sent
    And a valid subscription request body with property "$.config.initialEvent" set to true
    When the request "create<xxx>Subscription" is sent
    Then the response code is 201 or 202
    And an event notification of the subscribed type is received on callback-url
    And notification body complies with the OAS schema at "#/components/schemas/CloudEvent"

########################### Error response scenarios ############################################
########################### Subscription creation scenarios #####################################

  @<xxx>_subscriptions_20_create_<xxx>_subscription_with_invalid_parameter
  Scenario:  Create <xxx> subscription with invalid parameter
    Given the request body is not compliant with the schema "#/components/schemas/SubscriptionRequest"
    When the request "create<xxx>Subscription" is sent
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_21_creation_of_subscription_with_expiry_time_in_past
  Scenario: Expiry time in past
    Given a valid <xxx> subscription request body
    And request body property "$.config.subscriptionExpireTime" in the past
    When the request "create<xxx>Subscription" is sent
    Then the response code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscription_22_creation_with_invalid_eventType
  Scenario: Subscription creation with invalid event type
    Given a valid <xxx> subscription request body
    And the request body property "$.types" is set to invalid value
    When the request "create<xxx>Subscription" is sent
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscription_23_invalid_protocol
  Scenario: Subscription creation with invalid protocol
    Given a valid <xxx> subscription request body
    And the request property "$.protocol" is not set to "HTTP"
    When the request "create<xxx>Subscription" is sent
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_PROTOCOL"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscription_24_invalid_credential
  Scenario: Subscription creation with invalid credential
    Given a valid <xxx> subscription request body
    And the request property "$.protocol" is set to "HTTP"
    And the request property "$.sinkCredential.credentialType" is not set to "ACCESSTOKEN" and is not set to "PRIVATE_KEY_JWT"
    When the request "create<xxx>Subscription" is sent
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscription_26_invalid_url
  Scenario: Subscription creation with invalid url
    Given a valid <xxx> subscription request body
    And the request property "$.protocol" is set to "HTTP"
    And the request property "$.sink" is set to "azerty"
    When the request "create<xxx>Subscription" is sent
    Then the response property "$.status" is 400
    And the response property "$.code" is "INVALID_SINK"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_27_no_authorization_header_for_create_subscription
  Scenario: No Authorization header for create subscription
    Given a valid <xxx> subscription request body
    And the request does not include the "Authorization" header
    When the request "create<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_28_expired_access_token_for_create_subscription
  Scenario: Expired access token for create subscription
    Given a valid <xxx> subscription request body and header "Authorization" is expired
    When the request "create<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_29_invalid_access_token_for_create_subscription
  Scenario: Invalid access token for create subscription
    Given a valid <xxx> subscription request body
    And header "Authorization" set to an invalid access token
    When the request "create<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

########################### Subscription retrieval scenarios #####################################

  @<xxx>_subscriptions_30_no_authorization_header_for_get_subscription
  Scenario: No Authorization header for get subscription
    Given header "Authorization" is not present
    And path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "retrieve<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_31_expired_access_token_for_get_subscription
  Scenario: Expired access token for get subscription
    Given the header "Authorization" is set to expired token
    And path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "retrieve<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_32_invalid_access_token_for_get_subscription
  Scenario: Invalid access token for get subscription
    Given the header "Authorization" set to an invalid access token
    And path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "retrieve<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_33_get_unknown_<xxx>_subscription_for_a_device
  Scenario:  Get method for <xxx> subscription with subscription-id unknown to the system
    Given the path parameter "subscriptionId" is set to a value not corresponding to any existing subscription
    When the request "retrieve<xxx>Subscription" is sent
    Then the response  code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

########################### Subscription list retrieval scenarios #####################################

  @<xxx>_subscriptions_40_no_authorization_header_for_list_subscription
  Scenario: No Authorization header for list subscription
    Given header "Authorization" is not present
    When the request "retrieve<xxx>SubscriptionList" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_41_expired_access_token_for_list_subscription
  Scenario: Expired access token for list subscription
    Given the header "Authorization" is set to expired token
    When the request "retrieve<xxx>SubscriptionList" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_42_invalid_access_token_for_list_subscription
  Scenario: Invalid access token for list subscription
    Given the header "Authorization" set to an invalid access token
    When the request "retrieve<xxx>SubscriptionList" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

########################### Subscription deletion scenarios #####################################

  @<xxx>_subscriptions_50_no_authorization_header_for_delete_subscription
  Scenario: No Authorization header for delete subscription
    Given header "Authorization" is set without a token
    And path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "delete<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_51_expired_access_token_for_delete_subscription
  Scenario: Expired access token for delete subscription
    Given header "Authorization" is set with an expired token
    And path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "delete<xxx>Subscription" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_52_invalid_access_token_for_delete_subscription
  Scenario: Invalid access token for delete subscription
    Given header "Authorization" set to an invalid access token
    And path parameter "subscriptionId" is set to the identifier of an existing <xxx> subscription
    When the request "delete<xxx>Subscription" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @<xxx>_subscriptions_53_delete_invalid_<xxx>_subscription
  Scenario:  Delete <xxx> subscription with subscription-id unknown to the system
    Given the path parameter "subscriptionId" is set to a value not corresponding to any existing subscription
    When the request "delete<xxx>Subscription" is sent
    Then the response code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

########Specific Subscription error scenario if multi-event is not permitted ################

  @<xxx>_subscriptions_60_create_with_unsupported_multiple_event_type
  Scenario: Multi event subscription not supported
    Given the API provider only allows one event to be subscribed per subscription request
    And a valid subscription request body
    And the request body property "$.types" is set to an array with 2 valid items
    When the request "create<xxx>Subscription" is sent
    Then the response code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MULTIEVENT_SUBSCRIPTION_NOT_SUPPORTED"
    And the response property "$.message" contains a user friendly text
