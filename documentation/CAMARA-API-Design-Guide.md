# CAMARA API Design Guide


This document outlines guidelines for API design within the CAMARA project, applicable to all APIs developed under the initiative.

<!-- TOC tocDepth:2..3 chapterDepth:2..3 -->

- [1. Introduction](#1-introduction)
  - [1.1. Conventions](#11-conventions)
  - [1.2. Common Vocabulary and Acronyms](#12-common-vocabulary-and-acronyms)
- [2. Data](#2-data)
  - [2.1. Common Data Types](#21-common-data-types)
  - [2.2. Data Definitions](#22-data-definitions)
- [3. Error Responses](#3-error-responses)
  - [3.1. Standardized Use of CAMARA Error Responses](#31-standardized-use-of-camara-error-responses)
  - [3.2. Error Responses - Device Object/Phone Number](#32-error-responses---device-objectphone-number)
  - [3.3. Error Responses - Mandatory Template for `info.description` in CAMARA API](#33-error-responses---mandatory-template-for-infodescription-in-camara-api)
- [4. Pagination, Sorting and Filtering](#4-pagination-sorting-and-filtering)
  - [4.1. Pagination](#41-pagination)
  - [4.2. Sorting](#42-sorting)
  - [4.3. Filtering](#43-filtering)
- [5. OpenAPI Sections](#5-openapi-sections)
  - [5.1. Reserved Words](#51-reserved-words)
  - [5.2. OpenAPI Version](#52-openapi-version)
  - [5.3. Info Object](#53-info-object)
  - [5.4. ExternalDocs Object](#54-externaldocs-object)
  - [5.5. Servers Object](#55-servers-object)
  - [5.6. Tags](#56-tags)
  - [5.7. Paths and Operations](#57-paths-and-operations)
  - [5.8. Components](#58-components)
- [6. Security](#6-security)
  - [6.1. Good Practices for Securing REST APIs](#61-good-practices-for-securing-rest-apis)
  - [6.2. Security Definition](#62-security-definition)
  - [6.3. Expressing Security Requirements](#63-expressing-security-requirements)
  - [6.4. Mandatory Template for `info.description` in CAMARA API](#64-mandatory-template-for-infodescription-in-camara-api)
  - [6.5. POST or GET for Transferring Sensitive or Complex Data](#65-post-or-get-for-transferring-sensitive-or-complex-data)
  - [6.6. Scope Naming](#66-scope-naming)
  - [6.7. Resource Access Restriction](#67-resource-access-restriction)
- [7. Versioning](#7-versioning)
  - [7.1. API Version (OAS `info` Object)](#71-api-version-oas-info-object)
  - [7.2. API Version in URL (OAS `servers` Object)](#72-api-version-in-url-oas-servers-object)
  - [7.3. API Versions Throughout the Release Process](#73-api-versions-throughout-the-release-process)
  - [7.4. Backward and Forward Compatibility](#74-backward-and-forward-compatibility)
- [8. External Documentation](#8-external-documentation)
- [Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier](#appendix-a-normative-infodescription-template-for-when-user-identification-can-be-from-either-an-access-token-or-explicit-identifier)

<!-- /TOC -->

## 1. Introduction
CAMARA uses the OpenAPI Specification (OAS) to describe its APIs. The following guidelines outline the restrictions and conventions to be followed within the OAS files by all CAMARA APIs.

### 1.1. Conventions
The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

### 1.2. Common Vocabulary and Acronyms

| **Term**       | Description                                                                                                                                                                                                                                                                                                                                         |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **API**        | Application Programming Interface. It is a rule & specification group (code) that applications follow to communicate between them, used as interface among programs developed with different technologies.                                                                                                                                          |
|**api-name**    | `api-name` is a kebab-case string used to create unique names or values of objects and parameters related to given API. For example, for Device Location Verification API, api-name is `location-verification`.|
| **Body**       | HTTP Message body (If exists) is used to carry the entity data associated with the request or response.                                                                                                    |
| **Camel Case** | It is a kind of define the fields’ compound name or phrases without whitespaces among words. It uses a capital letter at the beginning of each word. There are two different uses:<li>UpperCamelCase: When the first letter of each word is capital.</li><li>lowerCamelCase: Same to that Upper one, but with the first word in lowercase.</li> |
| **Header**     | HTTP Headers allow client and server send additional information joined to the request or response. A request header is divided by name (No case sensitive) followed by a colon and the header value (without line breaks). White spaces on the left hand from the value are ignored.                                                               |
| **HTTP**       | Hypertext Transfer Protocol (HTTP) is a communication protocol that allows the information transfer using files (XHTML, HTML…) in World Wide Web.                                                                                                                                                                                                   |
| **JSON**       | The JavaScript Object Notation (JSON) Data Interchange Format [RFC8259](https://datatracker.ietf.org/doc/html/rfc8259)                                                                                                                                                                                                                              |
| **JWT**        | JSON Web Token (JWT) is an open standard based on JSON [RFC7519](https://datatracker.ietf.org/doc/html/rfc7519)                                                                                                                                                                                                                                     |
| **Kebab-case** | Practice in the words denomination where the hyphen is used to separate words.                                                                                                                                                                                                                                                                      |
| **OAuth2**     | Open Authorization is an open standard that allows simple Authorization flows to be used in websites or applications. [RFC6749](https://datatracker.ietf.org/doc/html/rfc6749)                                                                                                                                                                      |
| **OIDC**       | [OpenId Connect](https://openid.net/specs/openid-connect-core-1_0.html) is standard based on OAuth2 that adds authentication and consent to OAuth2.                                                                                                                                                                                                 |
| **CIBA**       | [Client-Initiated Backchannel Authentication](https://openid.net/specs/openid-client-initiated-backchannel-authentication-core-1_0.html) is a standard based on OIDC that enables API consumers to initiate an authentication.                                                                                                                      |
| **REST**       | Representational State Transfer.                                                                                                                                                                                                                                                                                                                    |
| **TLS**        | Transport Layer Security is a cryptographic protocol that provides secured network communications.                                                                                                                                                                                                                                                  |
| **URI**        | Uniform Resource Identifier.                                                                                                                                                                                                                                                                                                                        |
| **Snake_case** | Practice in the words denomination where the underscore is used to separate words.                                                                                                                                                                                                                                                                  |



## 2. Data

This chapter outlines the common data types and structures used in CAMARA APIs, along with best practices for defining them.

### 2.1. Common Data Types

The aim of this clause is to detail standard data types that will be used over time in all definitions, as long as they satisfy the information that must be covered.

It should be noted
that this point is open to continuous evolution over time through the addition of possible new data structures.
To allow for proper management of this ever-evolving list, an external repository has been defined to that end.
This repository is referenced below.

[Link to Common Data Types documentation repository](../artifacts/CAMARA_common.yaml)


### 2.2. Data Definitions

This part captures a detailed description of all the data structures used in the API specification. For each of these data, the specification MUST contain:
- Name of the data object, used to reference it in other sections
- Data type (String, Integer, Object, etc.)
- If the data type is string it is RECOMMENDED to use the appropriate modifier property `format` and/or `pattern` whenever possible. The [OpenAPI Initiative Formats Registry](https://spec.openapis.org/registry/format/) contains the list of formats used in OpenAPI specifications.


  - If the format of a string is `date-time`, the following sentence MUST be present in the description: `It must follow [RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) and must have time zone.`
  - If the format of a string is `duration`, the following sentence MUST be present in the description: `It must follow [RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339#appendix-A) for duration`
    - Note: to avoid known ambiguity issues with duration strings, consider using intervals, which are anchored to a specific start and end date or time. Use of a start date or time string field in combination with the duration string field could help to mitigate ambiguity issues.

- If the data type is an object, list of required properties.
- List of properties within the object data, including:
   - Property name
   - Property description
   - Property type (String, Integer, Object, etc.)
   - Other properties by type:
      - String ones: min and max length
      - Integer ones: format (int32, int64), range, etc.

In this part, the error response structure MUST also be defined following the guidelines in [3. Error Responses](#3-error-responses).

#### 2.2.1. Usage of Discriminator

As explained in the OpenAPI documentation [here](https://spec.openapis.org/oas/v3.0.3#discriminator-object) usage of discriminator may
simplify serialization/deserialization process and so reduce resource consumption.

##### Inheritance

The `mappings` section is not mandatory in a discriminator, by default Class Name values are used to populate the property. You can use mappings to restrict usage to a subset of subclasses.
When it's possible, use Object Name as a key in the `mappings` section. This will simplify the work of providers and consumers who use OpenAPI code generators.

``` yaml
    IpAddr:
      type: object
      properties:
        addressType:
            type: string
      required:
         - addressType
      discriminator:
        propertyName: addressType
        mappings:
            - Ipv4Addr: '#/components/schemas/Ipv4Addr'   <-- use Object Name as mapping key to simplify usage
            - Ipv6Addr: '#/components/schemas/Ipv6Addr'

    Ipv4Addr:           <-- Object Name also known as Class Name, used as JsonName by OpenAPI generator
      allOf:            <-- extends IpAddr (no need to define addressType because it's inherited
        - $ref: '#/components/schemas/IpAddr'
        - type: object
          required:
            - address
          properties:
            address:
                type: string
                format: ipv4
        ...

    Ipv6Addr:
      allOf:            <-- extends IpAddr
        - $ref: '#/components/schemas/IpAddr'
        - type: object
          required:
            - address
          properties:
            address:
              type: string
              format: ipv6
        ...
```

##### Polymorphism

To help usage of a CAMARA object from strongly typed languages, prefer to use inheritance than polymorphism. Despite this, if you have to use it apply the following rules:

    - objects containing `oneOf` or `anyOf` section MUST include a discriminator defined by a `propertyName`
    - objects involved in `oneOf` / `anyOf` section MUST include the property designed by `propertyName`

The following sample illustrates this usage.

``` yaml
    IpAddr:
      oneOf:
        - $ref: '#/components/schemas/Ipv6Addr'
        - $ref: '#/components/schemas/Ipv4Addr'
      discriminator:
        propertyName: objectType <-- objectType property MUST be present in the objects referenced in oneOf

    Ipv4Addr: <-- object involved in oneOf MUST include the objectType property
      type: object
      required:
        - objectType
        - address
      properties:
        objectType:
          type: string
        address:
          type: string
          format: ipv4
        ...

    Ipv6Addr: <-- object involved in oneOf MUST include the objectType property
      type: object
      required:
        - objectType
        - address
      properties:
        objectType:
          type: string
        address:
          type: string
          format: ipv6
        ...

```

When IpAddr is used in a payload, the property `objectType` MUST be present to indicate the schema to use:

``` json
{
    "ipAddr": {
        "objectType": "Ipv4Addr",   <-- objectType indicates to use Ipv4Addr to deserialize this IpAddr
        "address": "192.168.1.1",
        ...
    }
}
```



## 3. Error Responses

To ensure interoperability, it is crucial to implement error management that strictly adheres to the error codes defined in the HTTP protocol.

An error representation MUST NOT differ from the representation of any resource. A main error message is defined with JSON structure with the following fields:
- A field `status`, which can be identified in the response as a standard code from a list of Hypertext Transfer Protocol (HTTP) response status codes.
- A unique error `code`, which can be identified and traced for more details. It MUST be human-readable; therefore, it MUST NOT be a numeric code. In turn, to achieve a better location of the error, you can reference the value or the field causing it, and include it in the message.
- A detailed description in `message` - in English language in API specification, it can be changed to other languages in implementation if needed.

All these aforementioned fields are mandatory in Error Responses.
`status` and `code` fields have normative nature, so as their use has to be standardized (see [3.1. Standardized use of CAMARA error responses](#31-standardized-use-of-camara-error-responses)). On the other hand, `message` is informative and within this document an example is shown.

The values of the `status` and `code` fields are normative (i.e. they have a set of allowed values), as defined in [CAMARA_common.yaml](../artifacts/CAMARA_common.yaml).

An example of JSON error structure is as follows:

```json
{
   "status": 400,
   "code": "INVALID_ARGUMENT",
   "message": "A human-readable description of what the event represents"
}
```

In error handling, different cases must be considered, even at the functional level that it is possible to modify the error message returned to the API consumer. For this error handling, there are two possible alternatives listed below:
- Error handling done with custom policies in the API admin tool.
- Error management performed in a service queried by API.

The essential requirements to consider would be:
- Error handling SHOULD be centralized in a single place.
- Customization of the generated error based on the error content returned by the final core service SHOULD be contemplated.
- Latency SHOULD be minimized in its management.

NOTE: When standardized AuthN/AuthZ flows are used, please refer to [6.2. Security definition](#62-security-definition), the format and content of Error Response for those procedures SHALL follow the guidelines of those standards.

### 3.1. Standardized Use of CAMARA Error Responses

This section aims to provide a common use of the fields `status` and `code` across CAMARA APIs.

In the following, we elaborate on the existing client errors. In particular, we identify the different error codes and cluster them into separate tables, depending on their nature:
- i) syntax exceptions
- ii) service exceptions
- iii) server errors

<font size="3"><span style="color: blue"> Syntax Exceptions </span></font>

| **Error status** |     **Error code**      | **Message example**                                                 | **Scope/description**                                                                                                           |
|:----------------:|:-----------------------:|---------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|
|       400        |   `INVALID_ARGUMENT`    | Client specified an invalid argument, request body or query param.  | Generic Syntax Exception                                                                                                        |
|       400        |   `{{SPECIFIC_CODE}}`   | `{{SPECIFIC_CODE_MESSAGE}}`                                         | Specific Syntax Exception regarding a field that is relevant in the context of the API (e.g. format of an amount)               |
|       400        |     `OUT_OF_RANGE`      | Client specified an invalid range.                                  | Specific Syntax Exception used when a given field has a pre-defined range or a invalid filter criteria combination is requested |
|       403        |   `PERMISSION_DENIED`   | Client does not have sufficient permissions to perform this action. | OAuth2 token access does not have the required scope or when the user fails operational security                                |
|       403        | `INVALID_TOKEN_CONTEXT` | `{{field}}` is not consistent with access token.                    | Reflect some inconsistency between information in some field of the API and the related OAuth2 Token. This error SHOULD be used only when the scope of the API allows it to explicitly confirm whether or not the supplied identity matches that bound to the Three-Legged Access Token.                             |
|       409        |        `ABORTED`        | Concurrency conflict.                                               | Concurrency of processes of the same nature/scope                                                                               |
|       409        |    `ALREADY_EXISTS`     | The resource that a client tried to create already exists.          | Trying to create an existing resource                                                                                           |
|       409        |       `CONFLICT`        | A specified resource duplicate entry found.                         | Duplication of an existing resource                                                                                             |
|       409        |   `{{SPECIFIC_CODE}}`   | `{{SPECIFIC_CODE_MESSAGE}}`                                         | Specific conflict situation that is relevant in the context of the API                                                          |

<font size="3"><span style="color: blue"> Service Exceptions </span></font>

| **Error status** |        **Error code**         | **Message example**                                                        | **Scope/description**                                                                                                                                                        |
|:----------------:|:-----------------------------:|----------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|       401        |       `UNAUTHENTICATED`       | Request not authenticated due to missing, invalid, or expired credentials. A new authentication is required. | The request cannot be authenticated and a new authentication is required                                                            |
|       403        |      `{{SPECIFIC_CODE}}`      | `{{SPECIFIC_CODE_MESSAGE}}`                                                | Indicate a Business Logic condition that forbids a process not attached to a specific field in the context of the API (e.g QoD session cannot be created for a set of users) |
|       404        |          `NOT_FOUND`          | The specified resource is not found.                                       | Resource is not found                                                                                                                               |
|       404        |     `IDENTIFIER_NOT_FOUND`    | Device identifier not found.                                               | Some identifier cannot be matched to a device                                                                                                                              |
|       404        |      `{{SPECIFIC_CODE}}`      | `{{SPECIFIC_CODE_MESSAGE}}`                                                | Specific situation to highlight the resource/concept not found (e.g. use in device)                                                                                     |
|       422        |    `UNSUPPORTED_IDENTIFIER`   | The identifier provided is not supported.                                  | None of the provided identifiers is supported by the implementation                                                                                                     |
|       422        |    `UNNECESSARY_IDENTIFIER`   | The device is already identified by the access token.                      | An explicit identifier is provided when a device or phone number has already been identified from the access token                                                            |
|       422        |    `SERVICE_NOT_APPLICABLE`   | The service is not available for the provided identifier.                  | Service not applicable for the provided identifier                                                                                                                          |
|       422        |      `MISSING_IDENTIFIER`     | The device cannot be identified.                                           | An identifier is not included in the request and the device or phone number identification cannot be derived from the 3-legged access token                              |
|       422        |      `{{SPECIFIC_CODE}}`      | `{{SPECIFIC_CODE_MESSAGE}}`                                                | Any semantic condition associated to business logic, specifically related to a field or data structure                                                                   |
|       429        |       `QUOTA_EXCEEDED`        | Out of resource quota.                                                     | Request is rejected due to exceeding a business quota limit                                                                                                                |
|       429        |      `TOO_MANY_REQUESTS`      | Rate limit reached.                                                        | Access to the API has been temporarily blocked due to rate or spike arrest limits being reached                                                                                                                    |

<font size="3"><span style="color: blue"> Server Exceptions </span></font>

| **Error status** |      **Error code**      | **Message example**                                                                                           | **Scope/description**                                                                                                                    |
|:----------------:|:------------------------:|---------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
|       405        |   `METHOD_NOT_ALLOWED`   | The requested method is not allowed/supported on the target resource.                                         | Invalid HTTP verb used with a given endpoint                                                                                             |
|       406        |     `NOT_ACCEPTABLE`     | The server cannot produce a response matching the content requested by the client through `Accept-*` headers. | API Server does not accept the media type (`Accept-*` header) indicated by API client                                                    |
|       410        |          `GONE`          | Access to the target resource is no longer available.                                                         | Use in notifications flow to allow API Consumer to indicate that its callback is no longer available                                     |
|       412        |  `FAILED_PRECONDITION`   | Request cannot be executed in the current system state.                                                       | Indication by the API Server that the request cannot be processed in current system state                                                |
|       415        | `UNSUPPORTED_MEDIA_TYPE` | The server refuses to accept the request because the payload format is in an unsupported format.              | Payload format of the request is in an unsupported format by the Server. Should not happen                                               |
|       500        |        `INTERNAL`        | Unknown server error. Typically a server bug.                                                                 | Problem in Server side. Regular Server Exception                                                                                         |
|       501        |    `NOT_IMPLEMENTED`     | This functionality is not implemented yet.                                                                    | Service not implemented. The use of this code SHOULD be avoided as far as possible to get the objective to reach aligned implementations |
|       502        |      `BAD_GATEWAY`       | An upstream internal service cannot be reached.                                                               | Internal routing problem in the Server side that blocks to manage the service properly                                                   |
|       503        |      `UNAVAILABLE`       | Service Unavailable.                                                                                          | Service is not available. Temporary situation usually related to maintenance process in the server side                                  |
|       504        |        `TIMEOUT`         | Request timeout exceeded.                                                                                     | API Server Timeout                                                                                                                       |

> _NOTE 1: When no login has been performed or no authentication has been assigned, a non-descriptive generic error will always be returned in all cases, an `UNAUTHENTICATED` 401 “Request not authenticated due to missing, invalid, or expired credentials.” is returned, whatever the reason._

> _NOTE 2: A {{SPECIFIC_CODE}}, unless it may have traversal scope (i.e. re-usable among different APIs), SHALL follow this scheme for a specific API: {{API_NAME}}.{{SPECIFIC_CODE}}_

**Mandatory Errors** to be **documented in CAMARA API Spec YAML** are the following:

- For event subscriptions APIs, the ones defined in Event Subscription section of [CAMARA API Event Subscription and Notification Guide](/documentation/CAMARA-API-Event-Subscription-and-Notification.md)
- For event notifications flow, the ones defined in Event Notification section of [CAMARA API Event Subscription and Notification Guide](/documentation/CAMARA-API-Event-Subscription-and-Notification.md)
- For the rest of APIs:
  - Error status 401
  - Error status 403

NOTE:
The documentation of non-mandatory error statuses defined in section 3.1 depends on the specific considerations and design of the given API.
 - Error statuses 400, 404, 409, 422, 429: These error statuses SHOULD be documented based on the API design and the functionality involved. Subprojects evaluate the relevance and necessity of including these statuses in API specifications.
 - Error statuses 405, 406, 410, 412, 415, and 5xx: These error statuses are not documented by default in the API specification. However, they SHOULD be included if there is a relevant use case that justifies their documentation.
   - Special Consideration for error 501 NOT IMPLEMENTED to indicate optional endpoint:
     - The use of optional endpoints is discouraged in order to have aligned implementations
     - Only for exceptions where an optional endpoint can not be avoided and defining it in separate, atomic API is not possible - error status 501 SHOULD be documented as a valid response

### 3.2. Error Responses - Device Object/Phone Number

This section provides guidelines for error responses related to the `Device` object or `phoneNumber` field.

The Following table compiles the guidelines to be adopted:

| **Case #** | **Description**                                                            | **Error status** |         **Error code**         | **Message example**                                      |
|:----------:|:---------------------------------------------------------------------------|:----------------:|:------------------------------:|:---------------------------------------------------------|
|     0      | The request body does not comply with the schema                           |       400        |        INVALID_ARGUMENT        | Request body does not comply with the schema.            |
|     1      | None of the provided identifiers is supported by the implementation |       422        |     UNSUPPORTED_IDENTIFIER     | The identifier provided is not supported.                                 |
|     2      | Some identifier cannot be matched to a device                              |       404        |      IDENTIFIER_NOT_FOUND      | Device identifier not found.                             |
|     3      | An explicit identifier is provided when a device or phone number has already been identified from the access token |       422        |     UNNECESSARY_IDENTIFIER      | The device is already identified by the access token. |
|     4      | Service not applicable for the provided identifier                         |       422        |     SERVICE_NOT_APPLICABLE     | The service is not available for the provided identifier. |
|     5      | An identifier is not included in the request and the device or phone number identification cannot be derived from the 3-legged access token |       422       |      MISSING_IDENTIFIER      | The device cannot be identified. |

**NOTE:**
The `Device` object defined in [CAMARA_common.yaml](/artifacts/CAMARA_common.yaml) allows the API consumer to provide more than one device identifier. This is to allow the API consumer to provide additional information to a given API provider that might be useful for their implementation of the API, or to different API providers who might prefer different identifier types, or might not support all possible device identifiers.

Where an API consumer provides more than one device identifier, it is RECOMMENDED that the API provider include in the response a single device identifier (from those provided) which they are using to fulfil the API. This would apply even if the device identifiers do not all match the same device, as the API provider does not perform any logic to validate/correlate that the indicated device identifiers match the same device.

A `DeviceResponse` object is defined for this purpose, but is not mandatory to be used by any API. Where it is used, the API provider MUST indicate in responses which device identifier has been selected when multiple device identifiers were provided, and MAY also include this information when only a single device identifier has been provided. In all cases, the API provider MUST NOT respond with an identifier that was not originally provided by the API consumer.

An error MUST NOT be returned when the supplied device identifiers do not match to prevent the API consumer correlating identifiers for a given end user that they may not otherwise know. It is the responsibility of the API consumer to ensure that the identifiers they are using are associated with the same device. If they are unable to do that, only a single identifier SHOULD be provided to the API provider.

#### 3.2.1. Templates

##### Response template

A response will group all examples for the same operation and status code.
Schema is common for all errors.

```yaml
description: |
  The examples section includes the list of subcases for this status error code to be implemented. In each example `status` and `code` are normative for the specific error case. `message` MAY be adjusted or localized by the implementation.
headers:
  {{response_headers}}
content:
  application/json:
    schema:
      allOf:
        - $ref: "#/components/schemas/ErrorInfo"
        - type: object
          properties:
            status:
              enum:
                - <status>
            code:
              enum:
                - <code1>
                - <code2>
    examples:
      {{case_1}}:
        $ref: ""#/components/examples/{{case_1}}"
      {{case_2}}:
        $ref: ""#/components/examples/{{case_2}}"
```

##### Examples template

One case will be needed per row in the table above, following this template:

```yaml
components:
  examples:
    {{case_N}}:
      summary: {{Description}}
      description: {{informative description}}
      value:
        status: {{Error status}}
        code: {{Error code}}
        message: {{Message example}}
```

### 3.3. Error Responses - Mandatory Template for `info.description` in CAMARA API

The following template MUST be used as part of the API documentation in the `info.description` property of the CAMARA API specification to provide a common reference for API Consumers, API Developers and API Providers about not documented error responses in case they are supported by a given API implementation.

```md
# Additional CAMARA error responses

The list of error codes in this API specification is not exhaustive. Therefore the API specification MAY not document some non-mandatory error statuses as indicated in `CAMARA API Design Guide`.

Please refer to the `CAMARA_common.yaml` of the Commonalities Release associated to this API version for a complete list of error responses. The applicable Commonalities Release can be identified in the `API Readiness Checklist` document associated to this API version.

As a specific rule, error `501 - NOT_IMPLEMENTED` can be only a possible error response if it is explicitly documented in the API.

```



## 4. Pagination, Sorting and Filtering

Exposing a resource collection through a single URI can cause applications to fetch large amounts of data when only a subset of the information is required. For example, suppose a client application needs to find all orders with a cost greater than a specific value. You could retrieve all orders from the /orders URI and then filter these orders on the client side. This process is highly inefficient. It wastes network bandwidth and processing power on the server hosting the web API.
To alleviate the above-mentioned issues and concerns, Pagination, Sorting and Filtering MAY optionally be supported by the API provider. The Following subsections apply when such functionality is supported.

### 4.1. Pagination

Services can answer with a resource or article collections. Sometimes these collections MAY be a partial set due to performance or security reasons. Elements MUST be identified and arranged consistently on all pages. Paging can be enabled by default on the server side to mitigate denial of service or similar attack.

Services MUST accept and use these query parameters when paging is supported:
- `perPage`: number of resources requested to be provided in the response
- `page`: requested page number to indicate the start of the resources to be provided in the response (considering perPage page size)
- `seek`: index of last result read, to create the next/previous number of results. This query parameter is used for pagination in systems with more than 1000 records. `seek` parameter offers finer control than `page` and could be used one or another as an alternative. If both are used in combination (NOT RECOMMENDED) `seek` would mark the index starting from the page number specified by `page` and `perPage` [index = (page * perPage) + seek].

Services MUST accept and use these headers when paging is supported:
- `Content-Last-Key`: it allows specifying the key of the last resort provided in the response
- `X-Total-Count`: it allows indicating the total number of elements in the collection

If the server cannot meet any of the required parameters, it SHOULD return an error message.

The HTTP codes that the server will use as a response are:
- `200`: the response includes the complete list of resources
- `206`: the response does not include the complete list of resources
- `400`: request outside the range of the resource list

Petitions examples:
- `page=0 perPage=20`, which returns the first 20 resources
- `page=10 perPage=20`, which returns 20 resources from the 10th page (in terms of absolute index, 10 pages and 20 elements per page, means it will start on the 200th position as 10x20=200)

### 4.2. Sorting

Sorting the result of a query on a resource collection is based on two main parameters:

- `orderBy`: it contains the names of the attributes on which the sort is performed, with comma separated if there is more than one criteria.
  - When sorting is performed only based in one attribute it is allowed to not use and document this query param up to WG decision, clearly indicating within `order` query param on which attribute the sorting is based.
  - When sorting is perfomed based on several attributes, it is REQUIRED the use of this query param.
- `order`: sorting can be done in ascendent or descentent order.
  - To specify which sort criteria, it is needed to use "asc" or "desc" as query value.
  - Default value is agreed within CAMARA Subproject, as every API may have their own particularities/use cases.
  - When sorting is perfomed based on several attributes, `order` logic is performed based on the first attribute indicated within `orderBy` query param.

NOTE: Services MUST accept and use these parameters when sorting is supported. If a parameter is not supported, the service SHOULD return an error message.

For example, The list of orders is retrieved, sorted by rating, reviews and name with descending criteria.

```http
https://api.mycompany.com/v1/orders?orderBy=rating,reviews,name&order=desc
```

### 4.3. Filtering

Filtering consists of restricting the number of resources queried by specifying some attributes and their expected values. When filtering is supported, it is possible to filter a collection of multiple attributes at the same time and allow multiple values for a filtered attribute.

Next, it is specified how it should be used according to the filtering based on the type of data being searched for: a number or a date and the type of operation.

Note: Services MAY not support all attributes for filtering.  In case a query includes an attribute for which filtering is not supported, it MAY be ignored by the service.

#### 4.3.1. Filtering Security Considerations

As filtering may reveal sensitive information, privacy and security constraints have to be considered when defining query parameters, e.g. it SHOULD NOT be possible to filter using personal information (such as name, phone number or IP address).

#### 4.3.2. Filtering Operations

| **Operation**     | 	Numbers                     | 	Dates                                        |
|-------------------|------------------------------|-----------------------------------------------|
| Equal             | `GET .../?amount=807.24`	    | `GET .../?executionDate=2024-02-05T09:38:24Z` |
| Greater or equal	 | `GET .../?amount.gte=807.24` | `GET.../?executionDate.gte=2018-05-30`        |
| Strictly greater  | `GET .../?amount.gt=807.24`  | `GET.../?executionDate.gt=2018-05-30`         |
| smaller or equal	 | `GET .../?amount.lte=807.24` | `GET.../?executionDate.lte=2018-05-30`        |
| Strictly smaller  | `GET .../?amount.lt=807.24`  | `GET.../?executionDate.lt=2018-05-30`         |

And according to the filtering based on string and enums data, being searched for:

| **Operation** |	**Strings/enums** |
| ----- | ----- |
| equal | `GET .../?type=mobile` |
| non equal | `GET .../?type!=mobile` |
| Contains | `GET .../?type=~str` |

For boolean parameters the filter can be set for True or False value:

| **Operation** | 	**Booleans**    |
|---------------|-----------------------|
| True          | `GET .../?boolAttr=true`  |
| False         | `GET .../?boolAttr=false` |

**Additional rules**:
- The operator "`&`" is evaluated as an AND between different attributes.
- A Query Param (attribute) can contain one or n values separated by "`,`".
- For operations on numeric, date or enumerated fields, the parameters with the suffixes `.(gte|gt|lte|lt)$` need to be defined, which SHOULD be used as comparators for “greater—equal to, greater than, smaller—equal to, smaller than” respectively. Only the parameters needed for given field SHOULD be defined e.g., with `.gte` and `.lte` suffixes only.

**Examples**:
- <u>Equals</u>: to search devices with a particular operating system and version or type:
  - `GET /device?os=ios&version=17.0.1`
  - `GET /device?type=apple,android`
    - Search for several values separating them by "`,`".
- <u>Inclusion</u>: if we already have a filter that searches for "equal" and we want to provide it with the possibility of searching for "inclusion", we must include the character "~"
  - `GET /device?version=17.0.1`
    - Search for the exact version "17.0.1"
  - `GET /device?version=~17.0`
    - Look for version strings that include "17.0"
- <u>Greater than / less than</u>: new attributes need to be created with the suffixes `.(gte|gt|lte|lt)$` and included in `get` operation :

```yaml
paths:
  /users:
    get:
      parameters:
        - $ref: "#/components/parameters/StartCreationDate"
        - $ref: "#/components/parameters/AfterCreationDate"
        - $ref: "#/components/parameters/EndCreationDate"
        - $ref: "#/components/parameters/BeforeCreationDate"
    #...
components:
  parameters:
    StartCreationDate:   #<-- component name
      in: query
      name: creationDate.gte    <-- query attribute for "greater - equal to" comparison
      required: false
      schema:
        format: date-time
        type: string
    AfterCreationDate:
      in: query
      name: creationDate.gt
      required: false
      schema:
        format: date-time
        type: string
    EndCreationDate:
      in: query
      name: creationDate.lte
      required: false
      schema:
        format: date-time
        type: string
    BeforeCreationDate:
      in: query
      name: creationDate.lt
      required: false
      schema:
        format: date-time
        type: string
```

Then the parameters can be included in the query:
  - `GET /users?creationDate.gte=2021-01-01T00:00:00`
    - Find users with creationDate starting from 2021
  - `GET /users?creationDate.lt=2022-01-01T00:00:00`
    - Find users with creationDate before 2022
  - `GET /users?creationDate.gte=2020-01-01T00:00:00&creationDate.lte=2021-12-31T23:59:59`
    - Search for users created between 2020 and 2021



## 5. OpenAPI Sections

### 5.1. Reserved Words
To avoid issues with implementation using Open API generators reserved words MUST NOT be used in the following parts of an API specification:
- Path and operation names
- Path or query parameter names
- Request and response body property names
- Security schemes
- Component names
- OperationIds

A reserved word is one whose usage is reserved by any of the following Open API generators:
- [Python Flask](https://openapi-generator.tech/docs/generators/python-flask/#reserved-words)
- [OpenAPI Generator (Java)](https://openapi-generator.tech/docs/generators/java/#reserved-words)
- [OpenAPI Generator (Go)](https://openapi-generator.tech/docs/generators/go/#reserved-words)
- [OpenAPI Generator (Kotlin)](https://openapi-generator.tech/docs/generators/kotlin/#reserved-words)
- [OpenAPI Generator (Swift5)](https://openapi-generator.tech/docs/generators/swift5#reserved-words)


### 5.2. OpenAPI Version
The API functionalities MUST be implemented following the specifications of the [OpenAPI version 3.0.3](https://spec.openapis.org/oas/v3.0.3) using `api-name` as the filename and the `.yaml` or `.json` file extension.

### 5.3. Info Object

The `info` object MUST contain the properties described below.

Example `info` object along with brief explanations for each of the mandatory fields:

```yaml
info:
  # title without "API" in it, e.g. "Number Verification"
  title: Number Verification
  # description explaining the API, part of the API documentation
  # including mandatory text for "Authorization and authentication"
  # including mandatory text for "Additional CAMARA error responses"


  description: |
    This API allows to verify that the provided mobile phone number is the one used in the device. It
    verifies that the user is using a device with the same mobile phone number as it is declared.
    ### Authorization and authentication
    CAMARA guidelines defines a set of authorization flows ...
  # API version - Aligned to SemVer 2.0 according to CAMARA versioning guidelines
  version: 1.0.1
  # Name of the license and a URL to the license description
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html
  # CAMARA Commonalities minor version - x.y
  x-camara-commonalities: 0.5
```

#### 5.3.1. Title
`title` field describes the API shortly. The title SHALL NOT include the term "API" in it.

#### 5.3.2. Description
`description`field: There are no special restrictions specified in CAMARA for the documentation explaining API.
[CommonMark syntax](https://spec.commonmark.org/) MAY be used for rich text representation.
It is NOT RECOMMENDED to link images outside of the Github API repository, since changes to these images may be outside of the control of repository maintainers. Images SHOULD be preferably hosted within the API repository within the `documentation/API_documentation/resources` folder.

```markdown
![API Diagram](https://raw.githubusercontent.com/camaraproject/{apiRepository}/main/documentation/API_documentation/resources/diagram.png)
```

Some sections are REQUIRED, as defined in [Section 3.3](#33-error-responses---mandatory-template-for-infodescription-in-camara-api), [Section 6.4](#64-mandatory-template-for-infodescription-in-camara-api)
 or [Appendix A](#appendix-a-normative-infodescription-template-for-when-user-identification-can-be-from-either-an-access-token-or-explicit-identifier).

#### 5.3.3. Version
`version` field: APIs SHALL use the [versioning-format](https://lf-camaraproject.atlassian.net/wiki/x/3yLe) as specified by the release management working group.

#### 5.3.4. Terms of Service
`termsOfService` SHALL NOT be included. API providers may add this content when documenting their APIs.

#### 5.3.5. Contact Information
`contact` information SHALL NOT be included. API providers may add this content when documenting their APIs.

#### 5.3.6. License
The `license` object SHALL include the following fields:
```
license
  name: Apache 2.0
  url: https://www.apache.org/licenses/LICENSE-2.0.html
```

#### 5.3.7. Extension Field
The API SHALL specify the Commonalities minor release number they are compliant to, by including the `x-camara-commonalities` extension field.

### 5.4. ExternalDocs Object
The `externalDocs` object SHALL have the following content:

```yaml
externalDocs:
  description: Product documentation at CAMARA
  url: https://github.com/camaraproject/{apiRepository}
  # {apiRepository} MUST be replaced by the CAMARA API Repository name where the API specification is hosted.
```


### 5.5. Servers Object

The `servers` object SHALL have the following content:

```yaml
servers:
  # apiRoot variable and the fixed base path containing <api-name> and <api-version> as defined below
  - url: {apiRoot}/<api-name>/<api-version>
    variables:
      apiRoot:
        default: http://localhost:9091
        description: API root, defined by the service provider, e.g. `api.example.com` or `api.example.com/somepath`
```

If more than one server object instance is listed, the `servers[*].url` property of each instance MUST have the same string for the `api-name` and `api-version`' in respective instance.

#### 5.5.1. api-name

`api-name` is what is specified as the base path, prior to the API version, in the `servers[*].url` property.

For the below example, the api-name would be `location-verification`.

```
 /location-verification/v1
```
`api-name` is a kebab-case string used to create unique names or values of objects and parameters related to given API.


#### 5.5.2. api-version

`api-version` SHALL be same as the `version` field in the `info` object and follow the rules defined in [7.2. API version in URL (OAS servers object)](#72-api-version-in-url-oas-servers-object).

For the below example, the api-version would be `v1`.

```
 /location-verification/v1
```

### 5.6. Tags
Global `tags` object MUST be defined if tags are used for API operations.

### 5.7. Paths and Operations

#### 5.7.1. Paths

Paths contain the exposed resources.
Paths MUST be "human-readable" to facilitate identification of the offered resources.  Using lowercase words and hyphenation (kebab-case) helps to achieve this best practice. For example: `/customer-segments`.

The paths at the business entity level SHOULD be nouns in plural form.
Verb paths SHOULD be used for action resources to differentiate from an actual resource creation. For example: `retrieve-location`.
Resources MUST NOT contain the method name.


##### Resource hierarchy
Hierarchy could be introduced with the concepts of entity and sub-entity:
- **Entity**: it is understood as enough relevant business objects to be identified as a product. An API defines a single entity.
- **Sub-entity**: it is understood as a business object that by itself has no business relevance. It is an object hierarchically related to an entity.

To make the hierarchy, the following aspects MUST be applied:
- Two levels of hierarchy SHOULD NOT be exceeded and SHOULD NOT be more than eight resources (6–8).

- Resources defined through paths establish a hierarchical relationship with each other:
  - `/<entity>`<br>
   `/<entity>/{<entityId>}`<br>
   `/<entity>/{<entityId>}/<subEntity>`<br>
   `/<entity>/{<entityId>}/<subEntity>/{<subEntityId>}`

The attribute MUST be identifying itself, it is not enough with "{id}":
```
    Incorrect: /users/{id}/documents/{documentId}
    Correct: /users/{userId}/documents/{documentId}
```

Reason is that if this resource is "extended" in the future and includes other identifiers, we would not know which of the entities the "{id}" parameter refers to.

It is RECOMMENDED that the identifier have a similar morphology on all endpoints. For example, “`xxxxId`”, where xxx is the name of the entity, it references:
   - ```/users/{userId}```
   - ```/accounts/{accountId}```
   - ```/vehicles/{vehicleId}```
   - ```/users/{userId}/vehicles/{vehicleId}```

#### 5.7.2. Operations
A resource has multiple operations identified by HTTP Verbs: `GET`, `PUT`, `POST`, `PATCH`, `DELETE`.

Summary MUST be defined on each operation.
Functionality methods MUST have a description.

Allowed content type ("application/json", "text/xml") SHOULD be defined.


OperationIds are defined in lowerCamelCase: For example: `helloWorld`.

#### 5.7.3. Tags

`tags` object for each API operation is OPTIONAL - Title Case is the RECOMMENDED style for tag names.


#### 5.7.4. Parameters

Parameter names are defined in lowerCamelCase: For example: `sessionId`.

All parameters MUST have a description.
All properties within the object MUST have a description.

#### 5.7.5. Request Bodies

All `requestBody` attributes MUST have a description. They can follow one of the two structures below:

**Case A:** The request body structure is explicitly detailed. This is typically used when the request body is not reusable across different operations.

```yaml
requestBody:
  description: <description>
  content:
    application/json:
      schema:
        $ref: "#/components/schemas/<schema-name>"
  required: true
```

**Case B:** The request body structure is referenced from a schema in `components.requestBodies`. This is usually the case when the request body is reusable across different operations.

```yaml
requestBody:
  $ref: '#/components/requestBodies/<schema-name>'
```

`GET` and `DELETE` HTTP methods MUST NOT accept a 'requestBody' attribute.


#### 5.7.6. Responses

All response objects MUST have a description. They typically consist of two parts:

- **Success response codes:** Their structure is explicitly detailed.
- **Error response codes:** Their structure is referenced to a schema in `components.responses`.

```yaml
responses:
  "2xx":
    description: <description>
    headers:
      x-correlator:
        $ref: "#/components/headers/x-correlator"
    content:
      application/json:
        schema:
          $ref: "#/components/schemas/<schema-name>"
  "4xx":
    $ref: "#/components/responses/<schema-name>"
  "5xx":
    $ref: "#/components/responses/<schema-name>"
```


### 5.8. Components

Common definitions in the global components section

#### 5.8.1. Schemas

UpperCamelCase SHOULD be used for schema names.
All properties within the object MUST have a description.

#### 5.8.2. Responses
UpperCamelCase SHOULD be used for response names.
All properties within the object MUST have a description.

#### 5.8.3. Parameters
Parameter names are defined in lowerCamelCase: For example: `sessionId`.

All parameters MUST have a description.
All properties within the object MUST have a description.

#### 5.8.4. Request Bodies
UpperCamelCase SHOULD be used for request body names.
All properties within the object MUST have a description.

#### 5.8.5. Headers

Special requirements related to HTTP headers.

##### x-correlator Header

With the aim of standardizing the request observability and traceability process, common headers that provide a follow-up of the E2E processes SHOULD be included. The table below captures these headers.

| Name           | Description                                   | Schema          | Location         | Required by API Consumer | Required in OAS Definition | 	Example                              |
|----------------|-----------------------------------------------|----------------------|------------------|--------------------------|----------------------------|----------------------------------------|
| `x-correlator` | 	Service correlator to make E2E observability | `type: string`  `pattern: ^[a-zA-Z0-9-_:;.\/<>{}]{0,256}$`     | Request / Response | No                       | Yes                        | 	b4333c46-49c0-4f62-80d7-f0ef930f1c46 |

When the API Consumer includes a non-empty `x-correlator` header in the request, the API Provider MUST echo this value in the response. If the `x-correlator` header is not included in the request, it is OPTIONAL for the API Provider to include it in the response with any valid value. It is RECOMMENDED to use UUID format for values.

In notification scenarios (i.e., POST request sent towards the listener indicated by `sink` address),
the use of the `x-correlator` is supported for the same aim as well.
When the API request includes the `x-correlator` header,
it is RECOMMENDED for the listener to include it in the response with the same value as was used in the request.
Otherwise, it is OPTIONAL to include the `x-correlator` header in the response with any valid value.

When an API client provides an `x-correlator` value not matching the pattern, error `400 - INVALID_ARGUMENT` MUST be returned.

NOTE: HTTP headers are case-insensitive. The use of the naming `x-correlator` is a guideline to align the format across CAMARA APIs.

##### Content-Type Header - clarification

The character set supported MUST only be UTF-8. The [JSON Data Interchange Format (RFC 8259)](https://datatracker.ietf.org/doc/html/rfc8259#section-8.1) states the following

```
JSON text exchanged between systems that are not part of a closed
ecosystem MUST be encoded using UTF-8 [RFC3629].

Previous specifications of JSON have not required the use of UTF-8
when transmitting JSON text.  However, the vast majority of JSON-
based software implementations have chosen to use the UTF-8 encoding,
to the extent that it is the only encoding that achieves
interoperability.
```

Implementers MAY include the UTF-8 character set in the Content-Type header value, for example, "`application/json; charset=utf-8`". However, the preferred format is to specify only the MIME type, such as "`application/json`". Regardless, the interpretation of the MIME type as UTF-8 is mandatory, even when only "`application/json`" is provided.

#### 5.8.6. Security Schemes

[Security schemes](https://spec.openapis.org/oas/v3.0.3#security-scheme-object) express security in OpenAPI.
Security can be expressed for the API as a whole or for each endpoint.

As specified in [Use of openIdConnect for securitySchemes](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#use-of-openidconnect-for-securityschemes), all CAMARA OpenAPI files MUST include the following scheme definition, with an adapted `openIdConnectUrl` in its components section. The schema definition is repeated in this document for illustration purposes, the correct format must be extracted from the link above.

```yaml
components:
  securitySchemes:
    openId:
      type: openIdConnect
      openIdConnectUrl: https://example.com/.well-known/openid-configuration
```

The key of the security scheme is arbitrary in OAS, but convention in CAMARA is to name it `openId`.

## 6. Security

### 6.1. Good Practices for Securing REST APIs

The following points can serve as a checklist to design the security mechanism of the REST APIs.

1. **HTTPS must always be used**.

   TLS ensures the confidentiality and integrity of the transported data and provides a way to authenticate the server.
   - With HTTP/2 or HTTP/3, performance improvements can be achieved due to better optimization and multiplexing of requests.
   - If HTTP 1.1 is used, usage of _TCP persistent connections_ is RECOMMENDED to achieve comparable performance.

2. **Authentication and authorization must be considered**

   CAMARA uses the authentication and authorization protocols and flows as described in the [Camara Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/r3.3/documentation/CAMARA-Security-Interoperability.md).\

3. **Input parameter validation**

  Validate the request parameters as the first step before they reach the application logic.
Implement strong validation checks and immediately reject the request if validation fails.
In the API response, provide relevant error message.

4. **Sensitive information must not be exposed in the URLs**

Usernames, passwords, session tokens, and API keys SHOULD NOT appear in the URL, as this can be captured in web server logs, making them easily exploitable.
See section [6.5. POST or GET for transferring sensitive or complex data](#65-post-or-get-for-transferring-sensitive-or-complex-data).

5. **Hashing passwords**.

   Passwords SHOULD never be transmitted in API bodies; however, if it becomes absolutely necessary, they MUST be hashed to protect the system and minimize potential damage in the event of a compromise. Utilizing strong hashing algorithms is crucial for password security. Effective options include Argon2, PBKDF2, bcrypt, and scrypt, which are designed to securely hash passwords and withstand various attack vectors.

For further guidance, please refer to the [OWASP API Security Project](https://owasp.org/www-project-api-security/). This resource offers comprehensive insights and best practices for securing APIs against common vulnerabilities and threats.

### 6.2. Security Definition

In general, all APIs MUST be secured to ensure who has access to what and for what purpose.
CAMARA uses OIDC and CIBA for authentication and consent collection and to determine whether the user has,
e.g. opted out of some API access.

The [Camara Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/r3.3/documentation/CAMARA-Security-Interoperability.md#purpose) defines that a single purpose is encoded in the list of scope values. The purpose values are defined by W3C Data Privacy Vocabulary as indicated in the [Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/r3.3/documentation/CAMARA-Security-Interoperability.md#purpose-as-a-scope).

### 6.3. Expressing Security Requirements

Security requirements of an API are expressed in OpenAPI through [Security Requirement Objects](https://spec.openapis.org/oas/v3.0.3#security-requirement-object).

The following is an example of how to use the `openId` security scheme defined above as described in [Use of security property](https://github.com/camaraproject/IdentityAndConsentManagement/blob/r3.3/documentation/CAMARA-API-access-and-user-consent.md#use-of-security-property):

```yaml
paths:
  {path}:
    {method}:
      ...
      security:
        - openId:
            - {scope}
```

The name `openId` MUST be same as defined in the `components.securitySchemes` section - see [5.8.6. Security schemes](#586-security-schemes).


### 6.4. Mandatory Template for `info.description` in CAMARA API

The documentation template available in [CAMARA API Specification - Authorization and authentication common guidelines](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#mandatory-template-for-infodescription-in-camara-api-specs) MUST be used as part of the authorization and authentication API documentation in the `info.description` property of the CAMARA API specification.

### 6.5. POST or GET for Transferring Sensitive or Complex Data

Using the GET operation to pass sensitive data potentially embeds this information in the URL
if contained in query or path parameters.
For example, this information can remain in browser history, could be visible to anyone who can read the URL,
or could be logged by elements along the route such as gateways and load balancers.
This increases the risk that the sensitive data may be acquired by unauthorised third parties.
Using HTTPS does not solve this vulnerability,
as the TLS termination points are not necessarily the same as the API endpoints themselves.

The classification of data tagged as sensitive SHOULD be assessed for each API project, but might include the following examples:
-  phone number (MSISDN) MUST be cautiously handled as it is not solely about the number itself, but also knowing something about what transactions are being processed for that customer
-  localisation information (such as latitude & longitude) associated with a device identifier as it allows the device, and hence customer, location to be known
-  physical device identifiers, such as IP addresses, MAC addresses or IMEI

In such cases, it is RECOMMENDED to use one of the following methods to transfer the sensitive data:
- When using `GET`, transfer the data using headers, which are not routinely logged or cached
- Use `POST` instead of `GET`, with the sensitive data being embedded in the request body which, again, is not routinely logged or cached

When the `POST` method is used:
- the resource in the path MUST be a verb (e.g. `retrieve-location` and not `location`) to differentiate from an actual resource creation
- the request body itself MUST be a JSON object and MUST be `required`, even if all properties are optional

It is also fine to use POST instead of GET:
- to bypass technical limitations, such as URL character limits (if longer than 4k characters) or passing complex objects in the request
- for operations where the response SHOULD NOT be kept cached, such as anti-fraud verifications or data that can change asynchronously (such as status information)

### 6.6. Scope Naming

To correctly define the scopes, when creating them, the following recommendations SHOULD be taken:
- **Appropriate granularity** - scopes SHOULD be granular enough to match the types of resources and permissions you want to grant
- **Use a common nomenclature for all resources** - scopes MUST be descriptive names and that there is no conflict between the different resources
- **Use the kebab-case nomenclature** to define API names, resources, and scope permissions
- **Use ":" a separator** between API name, protected resources, event-types and grant-levels for consistency

#### 6.6.1. APIs Which Do Not Deal with Explicit Subscriptions

Regarding scope naming for APIs, which do not deal with explicit subscriptions, the guidelines are:

* Define a scope per API operation with the structure:
```
    api-name:[resource:]action
```
where

* `api-name` is the API name specified as the base path, prior to the API version, in the `servers[*].url` property. For example, from `/location-verification/v1`, it would be `location-verification`.

* `resource` is OPTIONAL. For APIs with several `paths`, it MAY include the resource in the path. For example, from `/qod/v1/sessions/{sessionId}`, it would be `sessions`.

* `action`: There are two cases:
  - For POST operations with a verb, it will be the verb. For example, from `POST /location-verification/v1/verify`, it would be `verify`.
    - For endpoints designed as POST but with underlying logic retrieving information, a CRUD action `read` MAY be added. However, if it is a path with a single operation, and it is not expected to have more operations on it, the CRUD action is not necessary.
  - For CRUD operations on a resource in paths, it will be one of:
    - `create`: For operations creating the resource, typically `POST`.
    - `read`: For operations accessing to details of the resource, typically `GET`.
    - `update`: For operations modifying the resource, typically `PUT` or `PATCH`.
    - `delete`: For operations removing the resource, typically `DELETE`.
    - `write` : For operations creating or modifying the resource, when differentiation between `create` and `update` is not needed.

* Eventually we MAY need to add a level to the scope, such as `api-name:[resource:]action[:detail]`, to deal with cases when only a set of parameters/information has to be allowed to be returned. Guidelines should be enhanced when those cases happen.


##### Examples

| API                   | path          | method | scope                                             |
|-----------------------|---------------|--------|---------------------------------------------------|
| location-verification | /verify       | POST   | `location-verification:verify`                    |
| qod                   | /sessions     | POST   | `qod:sessions:create`, or<br>`qod:sessions:write` |
| qod                   | /qos-profiles | GET    | `qod:qos-profiles:read`                           |


#### 6.6.2. API-level Scopes (Sometimes Referred to as Wildcard Scopes in CAMARA)

The decision on the API-level scopes was made within the [Identity and Consent Management Working Group](https://github.com/camaraproject/IdentityAndConsentManagement) and is documented in the design guidelines to ensure the completeness of this document.
The scopes will always be those defined in the API specification YAML files. Thus, a scope would only provide access to all endpoints and resources of an API if it is explicitly defined in the API specification YAML file and agreed in the corresponding API Subproject.

### 6.7. Resource Access Restriction

In some CAMARA APIs there are functions to create resource (via POST) and then later query them via id and/or list (with GET) or delete them (via DELETE). For example we have sessions, payments, subscriptions, etc..

For the GET and DELETE operations we MUST restrict the resource(s) targeted depending on the information provided in the request. Basically we consider 2 filters:
* API client (`client_id`)
* access token

| Operation |  3-legged access token is used | 2-legged access token is used |
|-----------|--------------------------------|-------------------------------|
| GET/{id} | - The resource queried MUST have been created for the end user associated with the access token. <br> - The resource queried MUST have been created by the same API client given in the access token. | - The resource queried MUST have been created by the same API client given in the access token. |
| GET/ | - Return all resource(s) created by the API consumer that are associated with both the end user identified by the access token and the same API client given in the access token. | - Return all resource(s) created by the same API client given in the access token. |
| DELETE/{id} | - The resource to be deleted MUST have been created for the end user associated with the access token. <br> - The resource to be deleted MUST have been created by the same API client given in the access token. | - The resource to be deleted MUST have been created by the same API client given in the access token. |

## 7. Versioning

Versioning is a practice by which, when a change occurs in the API, a new version of that API is created.

API versions use a numbering scheme in the format: `x.y.z`

* x, y and z are numbers corresponding to MAJOR, MINOR and PATCH versions.
* MAJOR, MINOR and PATCH refer to the types of changes made to an API through its evolution.
* Depending on the change type, the corresponding number is incremented.
* This is defined in the [Semantic Versioning 2.0.0 (semver.org)](https://semver.org/) standard.

### 7.1. API Version (OAS `info` Object)

The API version is defined in the `version` field (in the `info` object) of the OAS definition file of an API.

```yaml
info:
  title: Number Verification
  description: text describing the API
  version: 2.2.0
  #...
```

In line with Semantic Versioning 2.0.0, the API with MAJOR.MINOR.PATCH version number, increments as follows:

1. The MAJOR version when an incompatible / breaking API change is introduced
2. The MINOR version when functionality is added that is backwards compatible
3. The PATCH version when backward compatible bugs are fixed

For more details on MAJOR, MINOR and PATCH versions, and how to evolve API versions, please see [API versioning](https://lf-camaraproject.atlassian.net/wiki/x/3yLe) in the CAMARA wiki.

It is RECOMMENDED to avoid breaking backward compatibility unless strictly necessary: new versions SHOULD be backwards compatible with previous versions. More information on how to avoid breaking changes can be found below.

### 7.2. API Version in URL (OAS `servers` Object)

The OAS file also defines the API version used in the URL of the API (in the `servers` object).

The API version in the `url` field only includes the "x" (MAJOR version) number of the API version as follows:

```yaml
servers:
    url: {apiRoot}/qod/v2
```

---

IMPORTANT: CAMARA public APIs with x=0 (`v0.x.y`) MUST use both the MAJOR and the MINOR version number separated by a dot (".") in the API version in the `url` field: `v0.y`.

---

```yaml
servers:
    url: {apiRoot}/number-verification/v0.3
```

This allows for both test and commercial usage of initial API versions as they are evolving rapidly, e.g. `/qod/v0.10alpha1`, `/qod/v0.10rc1`, or `/qod/v0.10`. However, it SHOULD be acknowledged that any initial API version may change.

### 7.3. API Versions Throughout the Release Process

A given API will go through various intermediate and public versions during its life cycle:
* intermediate versions are created during API version development, indicated by alpha and release-candidate version extensions 
* various public versions may be created due to updates to a published API 

Overall, during its life cycle, an API can have any of the following versions:

* work-in-progress (`wip`) API versions used during the development of an API before the first pre-release or in between pre-releases. Such API versions cannot be released and are not usable by API consumers.
* alpha (`x.y.z-alpha.m`) API versions (with extensions) for CAMARA internal API rapid development purposes
* release-candidate (`x.y.z-rc.n`) API versions (with extensions) for CAMARA internal API release bug fixing purposes
* public (`x.y.z`) API versions for usage in commercial contexts. These API versions only have API version number x.y.z (semver 2.0), no extension. Public APIs can have one of two maturity states (used in release management):
  * initial - indicating that the API is still not fully stable (x=0)
  * stable - indicate that the API has reached a certain level of maturity (x>0)

The following table gives the values of the API version (Info object) and the API version in the URL as used in the different API version types created during the API release process. For public API versions, this information is also dependent on whether it is an initial (x=0) or a stable public API version (x>0).

| API version type  |  API version  | initial (x=0) API version in URL | stable (x>0) API version in URL | API version can be released |
|-------------------|:-------------:|:--------------------------------:|:-------------------------------:|:---------------------------:|
| work-in-progress  |      wip      |               vwip               |              vwip               |             No              |
| alpha             | x.y.z-alpha.m |            v0.yalpham            |            vxalpham             | Yes (internal pre-release)  |
| release-candidate |   x.y.z-rc.n  |             v0.yrcn              |              vxrcn              | Yes (internal pre-release)  |
| public            |     x.y.z     |               v0.y               |               vx                |             Yes             |

The version in the URL is a shorthand of the API version. However, both v0.y.z-rc.1 and v0.y.z+1-rc.1 would be shortened to v0.yrc1 and, for x>0, both vx.y1.z1.0-rc.2 and vx.y2.z2-rc.2 would be shortened to vxrc2.

To avoid such clashes of the version in the URL, both alpha and release-candidate (rc) version extension numbers need to be numbered consecutively across the whole life cycle of an API, including its PATCH versions. 

For example, in the life cycle of a (MAJOR) version 1 of an API, alpha and rc extension numbers will evolve as follows: 

| API Version | v1.0.0-alpha.1 | v1.0.0-alpha.2 | v1.0.0-rc.1 | v1.0.0-rc.2 | v1.0.0 | v1.1.0-alpha.3 | v1.1.0-rc.3 | v1.1.0
| :---: | :---: | :---: | :--: | :--: | :--: | :--: | :--: | :--:
| **in URL**  | /v1alpha1 | /v1alpha2 | /v1rc1 | /v1rc2 | /v1 | /v1alpha3 | /v1rc3 | /v1

A precedence example of API versions throughout the full API life cycle is:

* 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1 < 3.0.0 < 3.0.1 (public versions only)
* 0.1.0 < 0.2.0-alpha.1 < 0.2.0-alpha.2 < 0.2.0-rc.1 < 0.2.0 (initial public version)
* 0.2.0 < 0.2.1-alpha.3 < 0.2.1-rc.2 < 0.2.1-rc.3 < 0.2.1 (patch (maintenance) update of initial public version)
* 0.2.1 < 1.0.0-alpha.1 < 1.0.0-rc.1 < 1.0.0 (stable public version)
* 1.0.0 < 1.1.0-alpha.2 < 1.1.0-alpha.3 < 1.1.0-rc.2 < 1.1.0-rc.3 < 1.1.0 (minor update of stable public version)
* 1.1.0 < 1.2.0-alpha.4 < 1.2.0-rc.4 < 1.2.0-rc.5 < 1.2.0 (minor update of stable public version)
* 1.2.0 < 2.0.0-alpha.1 < 2.0.0-alpha.2 < 2.0.0-rc.1 < 2.0.0-rc.2 < 2.0.0 (major update of stable public version)

For more information, please see [API versioning](https://lf-camaraproject.atlassian.net/wiki/x/3yLe) in the Release Management project wiki.

### 7.4. Backward and Forward Compatibility

Avoid breaking backward compatibility, unless strictly necessary, means that new versions SHOULD be compatible with previous versions.

Bearing in mind that APIs are continually evolving and certain operations will no longer be supported, the following considerations must be taken into account:

- Agree to discontinue an API version with consumers.
- Establish the obsolescence of the API in a reasonable period (6 months).
- Monitor the use of deprecated APIs.
- Remove deprecated APIs documentation.
- Never start using already deprecated APIs.

Types of modification:

- Not all API changes have an impact on API consumers. These are referred to as backward compatible changes.
- In case of such changes, the update produces a new API version that increases the MINOR or PATCH version number.
- The update can be deployed transparently as it does not change the endpoint of the API which only contains the MAJOR version number which has not changed, and all previously existing behaviour shall be the same.
- API consumers shall be notified of the new version availability so that they can take it into account.

Backward compatible changes to an API that **DO NOT** affect consumers:

- Adding a new endpoint
- Adding new operations on a resource (`PUT`, `POST`, ...).
- Adding optional input parameters to requests on existing resources. For example, adding a new filter parameter in a GET on a collection of resources.
- Changing an input parameter from mandatory to optional. For example: when creating a resource, a property of said resource that was previously mandatory becomes optional.
- Adding new properties in the representation of a resource returned by the server. For example, adding a new age field to a Person resource, which originally was made up of nationality and name.

Breaking changes to an API that **DO** affect consumers:

- Deleting operations or actions on a resource. For example:  POST requests on a resource are no longer accepted.
- Adding new mandatory input parameters. For example: now, to register a resource, a new `required` field must be sent in the body of the request.

- Modifying or removing an endpoint (breaks existing queries)
- Changing input parameters from optional to mandatory. For example: when creating a Person resource, the age field, which was previously optional, is now mandatory.
- Modifying or removing a mandatory parameter in existing operations (resource verbs). For example, when consulting a resource, a certain field is no longer returned. Another example: a field that was previously a string is now numeric.
- Modifying or adding new responses to existing operations. For example: creating a resource can return a 412 response code.

Compatibility management:

To ensure this compatibility, the following guidelines MUST be applied.

**As API provider**:
- Never change an endpoint name; instead, add a new one and mark the original one for deprecation in a MINOR change and remove it in a later MAJOR change (see semver FAQ entry: https://semver.org/#how-should-i-handle-deprecating-functionality)
- If possible, do the same for attributes
- New fields should always be added as optional.
- Postel's Law: “<em>Be conservative in what you do, be liberal in what you accept from others</em>”. When you have input fields that need to be removed, mark them as unused, so they can be ignored.
- Do not change the field’s semantics.
- Do not change the field’s order.
- Do not change the validation rules of the request fields to more restrictive ones.
- If you use collections that can be returned with no content, then answer with an empty collection and not null.
- Layout pagination support from the start.

Make the information available:
- provide access to the new API version definition file (via a link or dedicated endpoint)
- if possible, do the same to get the currently implemented API version definition file

**As API consumer**:
- Tolerant reader: if it does not recognize a field when faced with a response from a service, do not process it, but record it through the log (or resend it if applicable).
- Ignore fields with null values.
- Variable order rule: DO NOT rely on the order in which data appears in responses from the JSON service, unless the service explicitly specifies it.
- Clients MUST NOT transmit personally identifiable information (PII) parameters in the URL. If necessary, use headers.


## 8. External Documentation

- [OpenAPI Version 3.0 Guide](https://swagger.io/docs/specification/v3_0/basic-structure/)


## Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier

When an API requires a User (as defined by the [ICM Glossary](https://github.com/camaraproject/IdentityAndConsentManagement/blob/r3.3/documentation/CAMARA-API-access-and-user-consent.md#glossary-of-terms-and-concepts)) to be identified in order to get access to that User's data (as Resource Owner), the User can be identified in one of two ways:
- If the access token is a Three-Legged Access Token, then the User will already have been associated with that token by the API provider, which in turn may be identified from the physical device that calls the `/authorize` endpoint for the OIDC authorisation code flow, or from the `login_hint` parameter of the OIDC CIBA flow (which can be a device IP, phone number or operator token). The `sub` claim of the ID token returned with the access token will confirm that an association with the User has been made, although this will not identify the User directly given that the `sub` will not be a globally unique identifier nor contain PII as per the [CAMARA Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/r3.3/documentation/CAMARA-Security-Interoperability.md#id-token-sub-claim) requirements.
- If the access token is a Two-Legged Access Token, no User is associated with the token, and hence an explicit identifier MUST be provided. This is typically either a `Device` object named `device`, or a `PhoneNumber` string named `phoneNumber`. Both of these schema are defined in the [CAMARA_common.yaml](/artifacts/CAMARA_common.yaml) artifact. In both cases, it is the User that is being identified, although the `device` identifier allows this indirectly by identifying an active physical device.

If an API provider issues Three-Legged Access Tokens for use with the API, the following error may occur:
- **Both a Three-Legged Access Token and an explicit User identifier (device or phone number) are provided by the API consumer.**

  Whilst it might be considered harmless to proceed if both identify the same User, returning an error only when the two do not match would allow the API consumer to confirm the identity of the User associated with the access token, which they might otherwise not know. Although this functionality is supported by some APIs (e.g. Number Verification, KYC Match), for others it may exceed the scope consented to by the User.

  If the API scope DOES NOT allow explicit confirmation as to whether the identifiers match, a `422 UNNECESSARY_IDENTIFIER` error MUST be returned whether the identifiers match or not.

  If the API scope DOES allow explicit confirmation as to whether the identifiers match, a `403 INVALID_TOKEN_CONTEXT` error MUST be returned if the identifiers do not match and the mismatch is not indicated using some other mechanism (e.g. as an explicit field in the API response body).

If an API provider issues Two-Legged Access Tokens for use with the API, the following error may occur:
- **Neither a Three-legged Access Token nor an explicit User identifier (device or phone number) are provided by the API consumer.**

  One or other MUST be provided to identify the User.

  In this case, a `422 MISSING_IDENTIFIER` error code MUST be returned, indicating that the API provider cannot identify the User from the provided information.

The documentation template below is RECOMMENDED to be used as part of the `info.description` API documentation to explain to the API consumer how the pattern works.

This template is applicable to CAMARA APIs which:
- require the User (i.e. Resource Owner) to be identified; and
- may have implementations which accept Two-Legged Access Tokens; and
- do NOT allow the API to confirm whether or not the optional User identifier (`device` or `phoneNumber`) matches that associated with the Three-Legged Access Token

The template SHOULD be customised for each API using it by deleting one of the options where marked by (*)

```md
# Identifying the [ device | phone number ](*) from the access token

This API requires the API consumer to identify a [ device | phone number ](*) as the subject of the API as follows:
- When the API is invoked using a two-legged access token, the subject will be identified from the optional [`device` object | `phoneNumber` field](*), which therefore MUST be provided.
- When a three-legged access token is used however, this optional identifier MUST NOT be provided, as the subject will be uniquely identified from the access token.

This approach simplifies API usage for API consumers using a three-legged access token to invoke the API by relying on the information that is associated with the access token and was identified during the authentication process.

## Error handling:

- If the subject cannot be identified from the access token and the optional [`device` object | `phoneNumber` field](*) is not included in the request, then the server will return an error with the `422 MISSING_IDENTIFIER` error code.

- If the subject can be identified from the access token and the optional [`device` object | `phoneNumber` field](*) is also included in the request, then the server will return an error with the `422 UNNECESSARY_IDENTIFIER` error code. This will be the case even if the same [ device | phone number ](*) is identified by these two methods, as the server is unable to make this comparison.
```
