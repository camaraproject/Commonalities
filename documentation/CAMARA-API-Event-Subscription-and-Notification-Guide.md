# CAMARA API Event Subscription and Notification Guide

This document outlines specifics guidelines for API design within the CAMARA project, applicable to all APIs that provide capabilities for event subscription and notification management.

For general API design guidelines, please refer to [CAMARA API Design Guide](/documentation/CAMARA-API-Design-Guide.md).

<!-- TOC tocDepth:2..3 chapterDepth:2..3 -->

- [1. Introduction](#1-introduction)
  - [1.1. Conventions](#11-conventions)
  - [1.2. Common requirements](#12-common-requirements)
- [2. Event Subscription](#2-event-subscription)
  - [2.1. Instance-based (Implicit) Subscription](#21-instance-based-implicit-subscription)
  - [2.2. Resource-based (Explicit) Subscription](#22-resource-based-explicit-subscription)
  - [2.3. Event Versioning](#23-event-versioning)
- [3. Event Notification](#3-event-notification)
  - [3.1. Event Notification Definition](#31-event-notification-definition)
  - [3.2. `subscription-started` Event](#32-subscription-started-event)
  - [3.3. `subscription-updated` Event](#33-subscription-updated-event)
  - [3.4. `subscription-ended` Event](#34-subscription-ended-event)
  - [3.5. Error Definition for Event Notification](#35-error-definition-for-event-notification)
  - [3.6. Correlation Management](#36-correlation-management)
  - [3.7. Notification Examples](#37-notification-examples)
- [4. Security](#4-security)
  - [4.1. Scope Naming](#41-scope-naming)
  - [4.2. Abuse Protection](#42-abuse-protection)
  - [4.3. Notifications Security Considerations](#43-notifications-security-considerations)

<!-- /TOC -->

## 1. Introduction

To provide event-based interaction, the CAMARA API could offer capabilities for subscription and notification management.
A subscription allows an API consumer to request the reception of event notifications at a given URL (callback address) for a specific context.
A notification is the publication at the listener address regarding an occurred event. Managed event types are explicitly defined in the CAMARA OpenAPI Specification (OAS) documents.

### 1.1. Conventions
The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

### 1.2. Common requirements

The common guidelines outlined in the [CAMARA API Design Guide](/documentation/CAMARA-API-Design-Guide.md) SHOULD be followed in CAMARA APIs for subscription and notification management.

## 2. Event Subscription

We distinguish two types of subscriptions:
- Instance-based subscription (implicit creation)
- Resource-based subscription (explicit creation)

### 2.1. Instance-based (Implicit) Subscription

An instance-based subscription is a subscription indirectly created, additionally to another resource creation.
For example, for a Payment request (in Carrier Billing API), in the `POST/payments`,
the API consumer could request to get event notification about **this** Payment request processing update.
The subscription is not an autonomous entity,
and its lifecycle is linked to the managed entity (the Payment resource in this case).
The subscription terminates with the managed entity.

Providing this capability is OPTIONAL for any CAMARA API depending on UC requirements.

If this capability is present in CAMARA API, the following attributes MUST be used in the POST request :

| attribute name | type   | attribute description                                                                                                                                                                                                                                                                                       | cardinality |
|----------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| sink           | string | https callback address where the notification must be POST-ed, `format: uri` SHOULD be used to require a string that is compliant with [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986).  The [security considerations](#43-notifications-security-considerations) SHOULD be followed.                | mandatory   |
| sinkCredential | object | Sink credential provides authentication or authorization information necessary to enable delivery of events to a target. In order to be updated in future this object is polymorphic. See detail below. It is RECOMMENDED for subscription consumer to provide credential to protect notification endpoint. | optional    |

Several types of `sinkCredential` could be available in the future, but for now only access token credential is managed.

``sinkCredential`` attributes table (MUST be access token for now):

| attribute name       | type             | attribute description                                                          | cardinality |
|----------------------|------------------|--------------------------------------------------------------------------------|-------------|
| credentialtype       | string           | Type of the credential - MUST be set to `ACCESSTOKEN` for now                  | mandatory   |
| accessToken          | string           | Access Token granting access to the POST operation to create notification      | mandatory   |
| accessTokenExpireUtc | string date-time | An absolute UTC instant at which the access token shall be considered expired. | mandatory   |
| accessTokenType      | string           | Type of access token - MUST be set to `Bearer` for now                         | mandatory   |

#### 2.1.1. Instance-based (Implicit) Subscription Example

Illustration with bearer access token (Resource instance representation):

```json
{
  "sink": "https://callback...",
  "sinkCredential": {
    "credentialType": "ACCESSTOKEN",
    "accessToken" : "eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiL..",
    "accessTokenExpireUtc" : "2024-12-06T14:37:56.147Z",
    "accessTokenType" : "bearer"
    }
}
```

### 2.2. Resource-based (Explicit) Subscription

A resource-based subscription is an event subscription managed as a resource. This subscription is explicit. An API endpoint is provided to request subscription creation.  As this event subscription is managed as an API resource, it is identified and operations to search, retrieve and delete it MUST be provided.

Note: It is perfectly valid for a CAMARA API to have several event types managed.
The subscription endpoint will be unique,
but the 'eventType' attribute is used to distinguish distinct events subscribed.

To ease developer adoption,
the pattern for Resource-based event subscription SHOULD be consistent with all API providing this feature.

CAMARA subscription model leverages **[CloudEvents](https://cloudevents.io/)** and is based on release [0.1-wip](https://github.com/cloudevents/spec/blob/main/subscriptions/spec.md) as it is a vendor-neutral specification for defining the format of subscription. A generic neutral CloudEvent subscription OpenAPI specification is available in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents/) directory (event-subscription-template.yaml).

To ensure consistency across Camara subprojects, it is necessary that explicit subscriptions are handled within separate API/s. It is mandatory to append the keyword "subscriptions" at the end of the API name. For e.g. device-roaming-subscriptions.yaml

#### 2.2.1. Event Subscription Management Operations

Four operations MUST be defined:

| operation | path                              | description                                                                                                                                                                                            |
|-----------|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| POST      | `/subscriptions`                  | Operation to request an event subscription. (*)                                                                                                                                                        |
| GET       | `/subscriptions`                  | Operation to retrieve a list of event subscriptions - could be an empty list.  e.g. `GET /subscriptions?type=org.camaraproject.device-roaming-subscriptions.v1.roaming-status&expiresAt.lt=2023-03-17` |
| GET       | `/subscriptions/{subscriptionId}` | Operation to retrieve an event subscription (**)                                                                                                                                                       |
| DELETE    | `/subscriptions/{subscriptionId}` | Operation to delete an event subscription (***)                                                                                                                                                        |

Notes:

(*) As the subscription could be created synchronously or asynchronously,
both status codes 201 and 202 MUST be described in the OpenAPI specification.

(**) If the `GET /subscriptions/{subscriptionId}` is not able to retrieve a recently created subscription in asynchronous mode, a 404 code is sent back.

(***) As the subscription deletion could be handled synchronously or asynchronously,
both status codes 202 and 204 MUST be described in the OpenAPI specification.

Note on the operation path:
The RECOMMENDED pattern is to use `/subscriptions` path for the subscription operation.
But an API design team, for a specific case, can append `/subscriptions` path with a prefix
(e.g. `/roaming/subscriptions` and `/connectivity/subscriptions`).
The rationale for using this alternate pattern SHOULD be explicitly provided
(e.g. the notification source for each of the supported events may be completely different,
in which case, separating the implementations is beneficial).

#### 2.2.2. Rules for Subscriptions Data Minimization

These rules apply for subscription with device identifier
- If 3-legged access token is used, the POST and GET responses MUST NOT provide any device identifier.
- If 2-legged access token is used, the presence of a device identifier in the response is mandatory and SHOULD be the same identifier type than the one provided in the request.

Application of data minimization design MUST be considered by the API Sub Project for event structure definition.

#### 2.2.3. Subscriptions Data Model

The following table provides `/subscriptions` attributes

| name           | type               | attribute description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | cardinality                  |
|----------------|--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| protocol       | string             | Identifier of a delivery protocol for the event notifications. The values follow the definitions of the [CloudEvent specification](https://github.com/cloudevents/spec/blob/main/subscriptions/spec.md#protocol). **Only** `HTTP` **is allowed for now**.                                                                                                                                                                                                                                                                                | mandatory                    |
| sink           | string             | The URL, to which event notifications shall be sent - `format: uri` SHOULD be used to require a string that is compliant with [RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986). The URI-scheme SHALL be set according to the definition of the `protocol` value, e.g. the URI-scheme is `https` when `HTTP`is the value of the `protocol` property. The [security considerations](43#notifications-security-considerations) SHOULD be followed.                                                                                 | mandatory                    |
| sinkCredential | object             | Sink credential provides authorization information necessary to enable delivery of events to a target. In order to be updated in future this object is polymorphic. See detail below. To protect the notification endpoint providing sinkCredential is RECOMMENDED. <br> The sinkCredential MUST NOT be present in `POST` and `GET` responses.                                                                                                                                                                                       | optional                     |
| types          | SubscriptionEventType | Type of event subscribed. This attribute MUST be present in the `POST` request. It is REQUIRED by API project to provide an enum for this attribute. The event type MUST follow the format: `org.camaraproject.<api-name>.<event-version>.<event-name>` - see chapter [2.3. Event versioning](#23-event-versioning) - Note: An array of types could be passed. The decision to use multiple event types in a single subscription will be made at the API level. | mandatory                    |
| config         | object             | Implementation-specific configuration parameters needed by the subscription manager for acquiring events. In CAMARA we have predefined attributes like ``subscriptionExpireTime``, ``subscriptionMaxEvents`` or ``initialEvent``. See detail below.                                                                                                                                                                                                                                                                                      | mandatory                    |
| id             | string             | Identifier of the event subscription - This attribute MUST NOT be present in the POST request as it is provided by API server                                                                                                                                                                                                                                                                                                                                                                                                            | mandatory in server response |
| startsAt       | string - date-time | Date when the event subscription will begin/began. This attribute MUST NOT be present in the `POST` request as it is provided by API server. It MUST be present in `GET` endpoints                                                                                                                                                                                                                                                                                                                                                       | optional                     |
| expiresAt      | string - date-time | Date when the event subscription will expire. This attribute MUST NOT be present in the `POST` request as it is provided (optionally) by API server. This attribute MUST be provided by the server if subscriptionExpireTime is provided in the request and server is not able to handle it.                                                                                                                                                                                                                                                                                                                                                                                 | optional                     |
| status         | string             | Current status of the subscription - Management of Subscription state engine is not mandatory for now. Note: not all statuses MAY be considered to be implemented. See below status table.                                                                                                                                                                                                                                                                                                                                               | optional                     |

``sinkCredential`` attributes table (MUST be only access token for now):

| attribute name       | type               | attribute description                                                          | cardinality |
|----------------------|--------------------|--------------------------------------------------------------------------------|-------------|
| credentialtype       | string             | Type of the credential - MUST be set to `ACCESSTOKEN` for now                  | mandatory   |
| accessToken          | string             | Access Token granting access to the POST operation to create notification      | mandatory   |
| accessTokenExpireUtc | string - date-time | An absolute UTC instant at which the access token shall be considered expired. | mandatory   |
| accessTokenType      | string             | Type of access token - MUST be set to `bearer` for now                         | mandatory   |

Note about expired accessToken:
when a notification is sent to the sink endpoint with sinkCredential it could occur a response back from the listener with an error about expired token.
In this case, the subscription will shift to EXPIRED status.
(as we do not have as of now capability to allow consumer to modify `subscription`).
Remark: This action will trigger a subscription-ended event with terminationReason set to "ACCESS_TOKEN_EXPIRED"
(probably this notification will also get the EXPIRED status answer).

`config` attributes table:

| attribute name         | type               | attribute description                                                                                                                                                                                                                                                                                                               | cardinality |
|------------------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| subscriptionMaxEvents  | integer            | Identifies the maximum number of event reports to be generated (>=1) - Once this number is reached, the subscription ends. Up to API project decision to keep it.                                                                                                                                                                   | optional    |
| subscriptionDetail     | object             | Object defined for each event subscription depending on the event. This is in this object that for example the device identifier will be provided (see example below).                                                                                                                                                              | mandatory   |
| subscriptionExpireTime | string - date-time | The subscription expiration time (in date-time format) requested by the API consumer. It must follow [RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) and must have time zone. Up to API project decision to keep it.                                                                                                                                                                                                        | optional    |
| initialEvent           | boolean            | Set to true by API consumer if consumer wants to get an event as soon as the subscription is created and current situation reflects event request. Example: Consumer request Roaming event. If consumer sets initialEvent to true and device is in roaming situation, an event is triggered. Up to API project decision to keep it. | optional    |

**Note** on combined usage of initialEvent and subscriptionMaxEvents:
Unless explicitly decided otherwise by the API Sub Project, if an event is triggered following initialEvent set to `true`, this event will be counted towards subscriptionMaxEvents (if provided).
It is RECOMMENDED to provide this clarification in all subscription APIs featuring subscriptionMaxEvents and initialEvent.

**Subscription status value table**:

Managing subscription is a draft feature, and it is not mandatory for now. An API project could decide to use/not use it. A list of status is provided for global consistency.

| status               | definition                                                                                                                                                                                                                                                            |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ACTIVATION_REQUESTED | Subscription creation (POST) is triggered but subscription creation process is not finished yet.                                                                                                                                                                      |
| ACTIVE               | Subscription creation process is completed. Subscription is fully operative.                                                                                                                                                                                          |
| INACTIVE             | Subscription is temporarily inactive, but its workflow logic is not deleted. INACTIVE could be used when an user initially provided consent for the event monitor and then later denied this consent. For now we did not provide capability to reactive subscription. |
| EXPIRED              | Subscription is ended (no longer active). This status applies when subscription is ended due to max event reached, expire time reached or access token indicated for notification security (i.e. sinkCredential) expiration time reached.                             |
| DELETED              | Subscription is ended as deleted (no longer active). This status applies when subscription information is kept (i.e. subscription workflow is no longer active but its meta-information is kept).                                                                     |

#### 2.2.4. Error Definition for Resource-based (Explicit) Subscription

Error definition described in this guideline applies for subscriptions.

The Following Error codes MUST be present:
* for `POST`: 400, 401, 403, 409, 429
  * If use of multiple event types in a single subscription is allowed errors 422: MULTIEVENT_SUBSCRIPTION_NOT_SUPPORTED and MULTIEVENT_COMBINATION_TEMPORARILY_NOT_SUPPORTED SHOULD be defined.
* for `GET`: 400, 401, 403
* for `GET .../{subscriptionId}`: 400, 401, 403, 404
* for `DELETE`: 400, 401, 403, 404

Please see in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents) directory ``event-subscription-template.yaml`` for more information and error examples.

#### 2.2.5. Termination for Resource-based (Explicit) Subscription

4 scenarios of subscription termination are possible (business conditions may apply):

* case1: subscriptionExpireTime has been provided in the request and reached. The operator in this case has to terminate the subscription.
* case2: subscriptionMaxEvents has been provided in the request and reached. The operator in this case has to terminate the subscription.
* case3: subscriber requests the `DELETE` operation for the subscription (if the subscription did not have a subscriptionExpireTime or before subscriptionExpireTime expires).
* case4: subscription ends on operator request.

It could be useful to provide a mechanism to inform subscriber for all cases. In this case, a specific event type could be used.

_Termination rules regarding subscriptionExpireTime & subscriptionMaxEvents usage_
* When client side providing a `subscriptionExpireTime` and/or `subscriptionMaxEvents` service side has to terminate the subscription without expecting a `DELETE` operation.
* CAMARA does not impose limitations for `subscriptionExpireTime` or `subscriptionMaxEvents` but API providers MAY enforce limitations and MUST document them accordingly.
* If both `subscriptionExpireTime` and `subscriptionMaxEvents` are provided, the subscription will end when the first one is reached.
* When none `subscriptionExpireTime` and `subscriptionMaxEvents` are not provided, client side has to trigger a `DELETE` operation to terminate it.
* It is perfectly valid for client side to trigger a DELETE operation before `subscriptionExpireTime` and/or `subscriptionMaxEvents` reached.

#### 2.2.6. Resource-based (Explicit) Subscription Example

In this example, we illustrate a request for a device roaming status event subscription.
Requester did not provide an expected expiration time for the subscription
but requested to get an event if the device is in a roaming situation at subscription time
and set the max limit to event to 10.
In response, the server accepts this request and sets an event subscription to end one year later.
This is an illustration, and each implementation is free to provide, or not, a subscription planned expiration date.

Request:

```bash
curl -X 'POST' \
  'http://localhost:9091/device-roaming-subscriptions/v1/subscriptions' \
  -H 'Authorization: Bearer c8974e592c2fa383d4a3960714' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d
 ```

 ```json
{
  "protocol" : "HTTP",
  "sink": "https://application-server.com",
  "types" : [
      "org.camaraproject.device-roaming-subscriptions.v1.roaming-status"
  ],
  "config": {
    "subscriptionDetail": {
      "device": {
        "phoneNumber": "+346661113334"
      }
    },
    "initialEvent" : true,
    "subscriptionMaxEvents" : 10
  }
}
```

response:

```http
201 Created
```

```json
{
  "protocol" : "HTTP",
  "sink": "https://application-server.com",
  "types" : [
      "org.camaraproject.device-roaming-subscriptions.v1.roaming-status"
  ],
  "config": {
    "subscriptionDetail": {
      "device": {
        "phoneNumber": "+346661113334"
      }
    },
    "initialEvent" : true,
    "subscriptionMaxEvents" : 10
  },
  "id": "456g899g",
  "startsAt": "2023-03-17T16:02:41.314Z",
  "expiresAt" : "2024-03-17T00:00:00.000Z",
  "status" : "ACTIVE"
}
```

Note:
If the API provides both patterns (indirect and resource-based),
and the API customer requests both (instance-based + subscription),
the two requests SHOULD be handled independently & autonomously.
Depending on server implementation, it is acceptable
when the event occurs that one or two notifications are sent to listener.

### 2.3. Event Versioning

For CAMARA subscription APIs, events are defined using the CloudEvents format. The CloudEvent specification provides some information on [CloudEvent versioning](https://github.com/cloudevents/spec/blob/main/cloudevents/primer.md#versioning-of-cloudevents), but some additional CAMARA event versioning guidelines are described in this section.

 [CloudEvent versioning](https://github.com/cloudevents/spec/blob/main/cloudevents/primer.md#versioning-of-cloudevents) states the following (quoted):

- When a CloudEvent's data changes in a backwardly-incompatible way, the value of the type attribute SHOULD generally change. The event producer is encouraged to produce both the old event and the new event for some time (potentially forever) in order to avoid disrupting consumers.
- When a CloudEvent's data changes in a backwardly-compatible way, the value of the type attribute SHOULD generally stay the same.

For CAMARA events, its `type` attribute is the base for event versioning as it contains the event version.

- The format of the `type` attribute value is defined as: `org.camaraproject.<api-name>.<event-version>.<event-name>`.
- The `<event-version>` has the format `vx`.
- `x` is the version number of the event’s structure.

Examples of CAMARA event types (= value of the `type` attribute) are:

- `org.camaraproject.device-roaming-status-subscriptions.v0.roaming-on`
- `org.camaraproject.device-roaming-status-subscriptions.v1.roaming-status`

---

The event version is independent of the API version that the event belongs to.

---

Example: A `v2` API can still use a `v1` event version if the event structure is unchanged with this MAJOR API version.

Events are considered to be “first class citizens” just like APIs and have their own versioning throughout their lifecycle. For example,

- The same event version MAY be supported by different versions of an API.
- An event client may be subscribed to a given event version from different API providers with different API versions, but expect to receive the same event data.

CAMARA event versioning extends the CloudEvent versioning as described in the following table:

Note: unless indicated otherwise, the below applies for both explicit and implicit event subscriptions.

| Event version  | CAMARA event versioning explanation  |
| ------------------- | ----------------------- |
| **v0 .. vn** (new subscription API)  | For an initial API `v0.y.z`, its event versions always start at `v0` and for any change to the event structure the event version SHALL follow the guidelines below. Stable APIs MUST use stable events with version number > 0. When publishing a first stable version of an API, any event version with `v0` SHALL be changed to `v1`, even if there is no change to the event structure. |
| **vn (n>0)** (backward compatible update of an event) | A MINOR or PATCH update of an event structure does not change the event version, but does imply a new MINOR or PATCH version of the API. Such changes to the event structure are backward compatible and SHOULD NOT impact event clients. |
| **vn → vn+1** (non backward compatible update of an event) | Any MAJOR change to an event structure implies the introduction of the next event version `vn+1`. There are two options: for details, please see below this table. |
| **v1** (adding a new event) | Introducing a new event to a stable subscription API implies that this event gets the version `v1`. The introduction of a new event to an existing API is considered as a MINOR API version update, as it SHALL NOT impact existing event clients. To force clients to take the new event into account, one can introduce it through a MAJOR API version change.    |
| removing an event or an event version | Removing an event or an event version from a stable subscription API implies a MAJOR update of the API version |

Any MAJOR change to an event structure implies the introduction of the next event version `vn+1`. There are two options:

- The updated event structure is introduced as an additional event version `vn+1`, resulting in a new MINOR API version. In this case, both the `vn` and `vn+1` event versions are part of the API definition. **It is RECOMMENDED to keep only the last 2 event versions (`vn+1` and `vn`) in the latest MAJOR API version**.
- The updated event structure is introduced as a replacement of the previous event version `vn`, resulting in a new MAJOR API version. In this case, the previous `vn` event version is deleted from the API definition, implying a breaking change for the event clients.

Note 1: The deletion of an event version implies always a MAJOR API version change.

Note 2: The decision to keep previous event version(s) is a decision of the API Sub Project team.

Note 3: In case of implicit event subscriptions, only replacement of the previous event version `vn` in the API definition is possible and will imply always a MAJOR API version change.

**Breaking and non-breaking changes for events**

Examples of breaking (non backward-compatible) changes related to events are

- adding a new version of an event without keeping the previous version in parallel
- removing an event version or all versions of an event
- breaking changes to an event structure (follows the same rules as for API response changes, see `CAMARA-API-design-Guide.md`)

Examples of non breaking (backward-compatible) changes related to events are

- adding a new event
- adding a new version of an existing event if the previous event version is kept
- non-breaking changes to an event structure (follows the same rules as for API response changes, see `CAMARA-API-design-Guide.md`)

## 3. Event Notification

### 3.1. Event Notification Definition

The API server uses the event notification endpoint to notify the API consumer that an event occurred.

CAMARA event notification leverages **[CloudEvents](https://cloudevents.io/)** and is based on release [1.0.2](https://github.com/cloudevents/spec/releases/tag/v1.0.2) as it is a vendor-neutral specification for defining the format of event data. A generic neutral CloudEvent notification OpenAPI specification is available in Commonalities/artifact directory (notification-as-cloud-event.yaml).

Note: The notification is the message posted on the listener side.
We describe the notification(s) in the CAMARA API using the `callbacks`.
From API consumer it could be confusing because this endpoint must be implemented on the business API consumer side.
This notice SHOULD be explicitly mentioned in all CAMARA API documentation featuring notifications.

Only Operation POST is provided for event notification and the expected response code is `204`.
The URL for this `POST` operation MUST be specified in the API specification as `{$request.body#/sink}`.
The event notification is represented in the JavaScript Object Notation (JSON) Data Interchange Format ([RFC8259](https://datatracker.ietf.org/doc/html/rfc8259)). Such [CloudEvents representation](https://github.com/cloudevents/spec/blob/main/cloudevents/formats/json-format.md) MUST use the media type `application/cloudevents+json`.

For consistency across CAMARA APIs, the uniform CloudEvents model MUST be used with the following rules:

| name            | type              | attribute description                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | cardinality   |
|-----------------|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| id              | string            | identifier of this event, that MUST be unique in the source context.                                                                                                                                                                                                                                                                                                                                                                                                                             | mandatory     |
| source          | string - URI      | identifies the context in which an event happened in the specific Provider Implementation. Often this will include information such as the type of the event source, the organization publishing the event or the process that produced the event. The exact syntax and semantics behind the data encoded in the URI is defined by the event producer.                                                                                                                                           | mandatory     |
| type            | string            | a value describing the type of event related to the originating occurrence. For consistency across API we mandate following pattern: `org.camaraproject.<api-name>.<event-version>.<event-name>` with the `event-version` with letter 'v' and a simple version number - see chapter [2.3. Event versioning](#23-event-versioning). An example is org.camaraproject.device-roaming-status-subscriptions.v1.roaming-status                                                                                                                                                        | mandatory     |
| specversion     | string            | version of the specification to which this event conforms - MUST be "1.0". As design guideline, this field will be modeled as an enum.                                                                                                                                                                                                                                                                                                                                                           | mandatory     |
| datacontenttype | string            | media-type that describes the event payload encoding, MUST be `application/json` for CAMARA APIs                                                                                                                                                                                                                                                                                                                                                                                                 | optional      |
| subject         | string            | describes the subject of the event - Not used in CAMARA notification.                                                                                                                                                                                                                                                                                                                                                                                                                            | optional      |
| time            | string  date-time | Timestamp of when the occurrence happened. If the time of the occurrence cannot be determined then this attribute MAY be set to some other time (such as the current time) by the CloudEvents producer, however all producers for the same `source` MUST be consistent in this respect. In other words, either they all use the actual time of the occurrence or they all use the same algorithm to determine the value used. (MUST adhere to CAMARA date-time recommendation based on RFC 3339) | mandatory (*) |
| data            | object            | event notification details payload described in each CAMARA API and referenced by its `type`                                                                                                                                                                                                                                                                                                                                                                                                     | optional (**) |

(*) Note: Attribute  `time` is tagged as optional in CloudEvents specification, but from CAMARA perspective we mandate to value this attributes.

(**) Event data (domain-specific information about the occurrence) are encapsulated within `data` object, its occurrence can be set to mandatory by given CAMARA API and its structure is dependent on each API:

| name           | type   | attribute description                                                              | cardinality |
|----------------|--------|------------------------------------------------------------------------------------|-------------|
| subscriptionId | string | The event subscription identifier - MUST be valued for Resource-based subscription | optional    |
| ...            | ...    | Specific attribute(s) related to the notification event                            | ...         |

Note: For operational and troubleshooting purposes it is relevant to accommodate use of `x-correlator` header attribute. API listener implementations have to be ready to support and receive this data.

### 3.2. `subscription-started` Event

Specific event notification type "subscription-started" is defined to inform listener about subscription initiation.
It is an OPTIONAL event. Recommended to be considered for asynchronous subscription creation models.

It is used when subscription creation request (POST /subscriptions) is managed asynchronously. For this specific event, the `data` MUST feature `initiationReason` attribute.

The following table lists values for `initiationReason` attribute:

| enum value | initiation reason |
| -----------|-------------------- |
| SUBSCRIPTION_CREATED | Subscription created by API Server |

Note1: This enumeration is also defined in `event-subscription-template.yaml` (placed in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents) directory).

Note2: The "subscription-started" notification is not counted in the `subscriptionMaxEvents`. (for example, if a client request set `subscriptionMaxEvents` to 2, it can receive 2 notifications, besides the notification sent for "subscription-started").

### 3.3. `subscription-updated` Event

Specific event notification type "subscription-updated" is defined to inform listener about subscription changes.
It is an OPTIONAL event.

It is used when the API Server manages `ACTIVE` and `INACTIVE` status and there are transitions of the subscription between each other. For this specific event, the `data` MUST feature `updateReason` attribute.

The following table lists values for `updateReason` attribute:

| enum value | update reason |
| -----------|-------------------- |
| SUBSCRIPTION_ACTIVE | API server transitioned susbcription status to `ACTIVE` |
| SUBSCRIPTION_INACTIVE | API server transitioned susbcription status to `INACTIVE` |

Note1: This enumeration is also defined in `event-subscription-template.yaml` (placed in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents) directory).

Note2: The "subscription-updated" notification is not counted in the `subscriptionMaxEvents`. (for example, if a client request set `subscriptionMaxEvents` to 2, it can receive 2 notifications, besides the notifications sent for "subscription-updated").

### 3.4. `subscription-ended` Event

Specific event notification type "subscription-ended" is defined to inform listener about subscription termination.

It is used when the `subscriptionExpireTime` or `subscriptionMaxEvents` has been reached, or, if the API server has to stop sending notifications prematurely, or if the subscription request is managed asynchronously by the server and it is not able to provide the service. For this specific event, the `data` MUST feature `terminationReason` attribute.

The following table lists values for `terminationReason` attribute:

| enum value | termination reason |
| -----------|-------------------- |
| NETWORK_TERMINATED | API server stopped sending notification |
| SUBSCRIPTION_EXPIRED | Subscription expire time (optionally set by the requester) has been reached |
| MAX_EVENTS_REACHED | Maximum number of events (optionally set by the requester) has been reached |
| ACCESS_TOKEN_EXPIRED | Access Token sinkCredential (optionally set by the requester) expiration time has been reached |
| SUBSCRIPTION_DELETED | Subscription was deleted by the requester |

Note1: This enumeration is also defined in `event-subscription-template.yaml` (placed in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents) directory).

Note2: The "subscription-ended" notification is not counted in the `subscriptionMaxEvents`. (for example, if a client request set `subscriptionMaxEvents` to 2, and later, received 2 notifications, then a third notification will be sent for "subscription-ended").

Note3: In the case of ACCESS_TOKEN_EXPIRED termination reason sending the notification once the token expired is useless. To avoid this case, following rules are defined :

- For explicit subscription, implementation SHOULD send ACCESS_TOKEN_EXPIRED termination event just before the token expiration date (the 'just before' value is at the hands of each implementation). The following sentence MUST be added for the `accessTokenExpiresUtc` attribute documentation: An absolute (UTC) timestamp at which the token shall be considered expired. In the case of an ACCESS_TOKEN_EXPIRED termination reason, implementation SHOULD notify the client before the expiration date."
- For implicit subscription following sentence MUST be added for the `accessTokenExpiresUtc` attribute documentation: "An absolute (UTC) timestamp at which the token shall be considered expired. Token expiration SHOULD occur after the expiration of the requested _resource_, allowing the client to be notified of any changes during the _resource_'s existence. If the token expires while the _resource_ is still active, the client will stop receiving notifications.". The _resource_ word MUST be replaced by the entity managed by the subscription (session, payment, etc.).

### 3.5. Error Definition for Event Notification

Error definitions are described in this guideline applies for event notification.

The Following Error codes MUST be present:
* for `POST`: 400, 401, 403, 410, 429

### 3.6. Correlation Management

To manage correlation between the subscription management and the event notification (as these are two distinct operations):
- use `subscriptionId` attribute (in `data` structure in the body) - this identifier is provided in event subscription and could be valued in each event notification.

Note: There is no normative enforcement to use any of these patterns, and they could be used on agreement between API consumer & providers.

### 3.7. Notification Examples

Example for Roaming status event notification - Request:

```bash
curl -X 'POST' \
  'https://application-server.com/v0/notifications' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer c8974e592c2fa383d4a3960714' \
  -H 'Content-Type: application/cloudevents+json' \
  -d
 ```

 ```json
{
  "id": 123654,
  "source": "https://notificationSendServer12.supertelco.com",
  "type": "org.camaraproject.device-roaming-subscriptions.v1.roaming-status",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "data": {
    "subscriptionId": "456g899g",
    "device": {
      "phoneNumber": "+123456789"
    },
    "roaming": true,
    "countryCode": 208,
    "countryName": "FR"
  },
  "time": "2023-01-17T13:18:23.682Z"
}
```

response:

```http
204 No Content
```

Example for subscription termination - Request:

```bash
curl -X 'POST' \
  'https://application-server.com/v0/notifications' \
  -H 'Accept: application/json' \
  -H 'Authorization: Bearer c8974e592c2fa383d4a3960714' \
  -H 'Content-Type: application/cloudevents+json' \
  -d
 ```

 ```json
{
  "id": 123658,
  "source": "https://notificationSendServer12.supertelco.com",
  "type": "org.camaraproject.api.device-roaming-subscriptions.v1.subscription-ended",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "data": {
    "subscriptionId": "456g899g",
    "device": {
      "phoneNumber": "+123456789"
    },
    "terminationReason": "SUBSCRIPTION_EXPIRED"
  },
  "time": "2023-01-19T13:18:23.682Z"
}
```

response:

```http
204 No Content
```

## 4. Security

### 4.1. Scope Naming

Regarding scope naming for APIs, which deal with explicit subscriptions, the guidelines propose some changes as compared to [generic rules](/documentation/CAMARA-API-Design-Guide.md#66-scope-naming), and this is described below:

Scopes SHOULD be represented as below for APIs that offer explicit event subscriptions with action read and delete, for example:

- API Name: `device-roaming-subscriptions`
- Grant-level, action on resource: `read`, `delete`

results in scope: `device-roaming-subscriptions:read`.
This type of formulation is not used for the creation action.

The format to define scopes for explicit subscriptions with action creation,
includes the event type in its formulation to ensure that consent is managed at the level of subscribed event types.
Scopes SHOULD be represented as below for APIs that offer explicit event subscriptions with action create, for example:

- API Name: `device-roaming-subscriptions`
- Event-type: `org.camaraproject.device-roaming-subscriptions.v0.roaming-on`
- Grant-level: action on resource: `create`

makes scope name: `device-roaming-subscriptions:org.camaraproject.device-roaming-subscriptions.v0.roaming-on:create`.


### 4.2. Abuse Protection

Any system permitting the registration and delivery of notifications to arbitrary HTTP endpoints holds the potential for abuse. This could occur if someone, either intentionally or unintentionally, registers the address of a system unprepared for such requests, or for which the registering party lacks authorization to perform such registration.

To prevent notification-replay attacks the API Consumer SHOULD inspect the notification's `id` and `time` fields. Whether to reject or ignore notifications that have already been received or that are too old is a API Consumer's policy decision.

To protect the sender, CloudEvents specification provides some guidance there: https://github.com/cloudevents/spec/blob/main/cloudevents/http-webhook.md#4-abuse-protection

Event Producers SHALL choose based on their internal security guidelines to implement measures based on the above guidance to ensure abuse protection. For e.g., An event producer might ask the subscriber to pre-register the notification URL at the time of app onboarding. If this registered notification URL doesn't match later with the notification URL in the request, the event producer can choose to reject the request with the relevant error code.

### 4.3. Notifications Security Considerations

As notifications may carry sensitive information, privacy and security have to be considered.

CloudEvents specification only provide some limited privacy and security guidance there: https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md#privacy-and-security

This document restricts the allowed values of `protocol` to `HTTP`. CloudEvents allows many protocols which each have their own security measures.
This Security Considerations need to be reconsidered if other protocols than `HTTP` are allowed.
Camara Notifications MUST use HTTPS. The value of `sink` MUST be an URL with url-scheme `https`.
The implementation of the Notification Sender MUST follow [10.2 Security Implementation](#102-security-implementation).

This document restricts the `credendentialType` to `ACCESSTOKEN`. Neither `PLAIN`nor `REFRESHTOKEN` are allowed.
This Security Considerations need to be reconsidered if other `credentialsType` values are allowed.

CloudEvent Security and Privacy considerations RECOMMEND protecting event **data** through signature and encryption. The value of the `data` field of the notifications SHOULD be signed and encrypted.
As Camara Notifications are JSON, Camara RECOMMENDS that the Camara Notification is signed and then encrypted using [JSON Web Signature (JWS)](https://datatracker.ietf.org/doc/html/rfc7515) and [JSON Web Encryption (JWE)](https://datatracker.ietf.org/doc/html/rfc7516).
The API Consumer and event producer have to agree which keys to use for signing and encryption e.g. at onboarding time or at subscription time.

It is RECOMMENDED that the API consumer inspects all the fields of the notification, especially `source` and `type`. It is RECOMMENDED that if the notification event data is signed, that then the `source` and the signature key are associated.

API Consumers SHOULD validate the schema of the notification event data that is defined by the API subproject. It is RECOMMENDED that additional fields are ignored. Reliance on additional fields is an interoperability issue. Additional fields can lead to security issues.
