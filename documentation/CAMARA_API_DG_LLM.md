

# CAMARA API Design Guide

- [CAMARA API Design Guide](#camara-api-design-guide)
  - [Introduction](#introduction)
    - [Conventions](#conventions)
    - [Common Vocabulary and Acronyms](#common-vocabulary-and-acronyms)
  - [Versioning](#versioning)
    - [API Version (OAS Info Object)](#api-version-oas-info-object)
    - [API Version in URL (OAS Servers Object)](#api-version-in-url-oas-servers-object)
    - [API Versions throughout the Release Process](#api-versions-throughout-the-release-process)
    - [Backward and Forward Compatibility](#backward-and-forward-compatibility)
  - [Error Responses](#error-responses)
    - [Standardized use of CAMARA error responses](#standardized-use-of-camara-error-responses)
      - [Syntax Exceptions](#syntax-exceptions)
      - [Service Exceptions](#service-exceptions)
      - [Server Exceptions](#server-exceptions)
    - [Error Responses - Device Object/Phone Number](#error-responses---device-objectphone-number)
  - [Data](#data)
    - [Common Data Types](#common-data-types)
    - [Data Definitions](#data-definitions)
      - [Usage of Discriminator](#usage-of-discriminator)
  - [Polymorphism](#polymorphism)
  - [Pagination, Sorting, and Filtering](#pagination-sorting-and-filtering)
    - [Pagination](#pagination)
    - [Sorting](#sorting)
    - [Filtering](#filtering)
      - [Filtering Security Considerations](#filtering-security-considerations)
      - [Filtering Operations](#filtering-operations)
  - [Security](#security)
    - [Security Definition](#security-definition)
    - [Expressing Security Requirements](#expressing-security-requirements)
    - [Mandatory template for `info.description` in CAMARA API specs](#mandatory-template-for-infodescription-in-camara-api-specs)
    - [Scope Naming](#scope-naming)
      - [APIs without Explicit Subscriptions](#apis-without-explicit-subscriptions)
        - [Examples](#examples)
      - [API-level Scopes](#api-level-scopes)
  - [OAS Sections](#oas-sections)
    - [OpenAPI Version](#openapi-version)
    - [Info Object](#info-object)
      - [Title](#title)
      - [License](#license)
      - [Extension Field](#extension-field)
    - [Servers Object](#servers-object)
      - [API-Name](#api-name)
      - [API-Version](#api-version)
    - [Paths](#paths)
    - [Components](#components)
  - [Schemas](#schemas)
      - [Headers](#headers)
      - [Security Schemes](#security-schemes)
    - [External Documentation](#external-documentation)
  - [Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier](#appendix-a-normative-infodescription-template-for-when-user-identification-can-be-from-either-an-access-token-or-explicit-identifier)
  - [Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier](#appendix-a-normative-infodescription-template-for-when-user-identification-can-be-from-either-an-access-token-or-explicit-identifier-1)
- [Identifying the Device or Phone Number from the Access Token](#identifying-the-device-or-phone-number-from-the-access-token)
  - [Error Handling](#error-handling)


This document outlines the guidelines for API design in the CAMARA project. These guidelines apply to every API developed under the CAMARA initiative.


## Introduction
Camara uses the OpenAPI Specification (OAS) to describe its APIs. The following guidelines outline the restrictions and conventions to be followed within the OAS YAML by all Camara APIs (referred to hereafter as APIs).


### Conventions

The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted according to the definitions in RFC 2119.



### Common Vocabulary and Acronyms

| **Term**       | Description                                                                                                                                                                                                                                                                                                                                         |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| **API**        | An Application Programming Interface (API) is a set of rules and specifications that applications follow to communicate with each other, used as an interface among programs developed with different technologies.                                                                                                                                          |
| **api-name**    | `api-name` is a kebab-case string used to create unique names or values of objects and parameters related to a given API. For example, for Device Location Verification API, `api-name` is `location-verification`.|
| **Body**       | The HTTP message body, if present, carries the entity data associated with the request or response.                                                                                                    |
| **Camel Case** | Camel case is a naming convention that defines compound names or phrases without spaces between words. It uses a capital letter at the beginning of each word. There are two types:<li>Upper Camel Case: The first letter of each word is capitalized.</li><li>Lower Camel Case: Same as Upper Camel Case, but with the first word in lowercase.</li> |
| **Header**     | HTTP headers allow clients and servers to send additional information along with the request or response. A request header consists of a name (case-insensitive) followed by a colon and the header value (without line breaks). Leading white spaces in the value are ignored.                                                               |
| **HTTP**       | The Hypertext Transfer Protocol (HTTP) is a communication protocol that enables the transfer of information using files (such as XHTML or HTML) over the World Wide Web.                                                                                                                                                                                                   |
| **JSON**       | The JavaScript Object Notation (JSON) Data Interchange Format, as specified in [RFC8259](https://datatracker.ietf.org/doc/html/rfc8259)                                                                                                                                                                                                                              |
| **JWT**        | A JSON Web Token (JWT) is an open standard based on JSON, as specified in [RFC7519](https://datatracker.ietf.org/doc/html/rfc7519)                                                                                                                                                                                                                                     |
| **Kebab-case** | Kebab case is a naming convention that uses hyphens to separate words.                                                                                                                                                                                                                                                                      |
| **OAuth2**     | Open Authorization is an open standard that enables simple authorization flows in websites or applications, as specified in [RFC6749](https://datatracker.ietf.org/doc/html/rfc6749)                                                                                                                                                                      |
| **OIDC**       | OpenId Connect is a standard based on OAuth2 that adds authentication and consent to OAuth2, as specified in [OpenId Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)                                                                                                                                 |
| **CIBA**       | Client-Initiated Backchannel Authentication is a standard based on OIDC that enables API consumers to initiate an authentication, as specified in [Openid Client-Initiated Backchannel Authentication Core 1.0](https://openid.net/specs/openid-client-initiated-backchannel-authentication-core-1_0.html) |
| **REST**       | Representational State Transfer is a software architecture style.                                                                                                                                                                                                                                                                                                                    |
| **TLS**        | Transport Layer Security is a cryptographic protocol that provides secure network communications.                                                                                                                                                                                                                                                  |
| **URI**        | A Uniform Resource Identifier is a string of characters that identifies a resource.                                                                                                                                                                                                                                                                                                                        |
| **Snake_case** | Snake case is a naming convention that uses underscores to separate words.                                                                                                                                                                                                                                                                  |


## Versioning

Versioning is a practice that involves creating a new version of an API whenever a change occurs. This change can be a significant update, a minor tweak, or a patch fix.

API versions are identified using a numbering scheme in the format `x.y.z`, where:

* `x`, `y`, and `z` represent MAJOR, MINOR, and PATCH versions, respectively.
* MAJOR, MINOR, and PATCH refer to the types of changes made to an API over time.
* The corresponding number is incremented depending on the type of change made.
* This versioning approach is based on the [Semantic Versioning 2.0.0 standard](https://semver.org/).



### API Version (OAS Info Object)

The API version is defined in the `version` field within the `info` object of the OAS definition file for an API.

```yaml
info:
  title: Number Verification
  description: text describing the API
  version: 2.2.0  
  #...
```

In accordance with Semantic Versioning 2.0.0, the API version follows the MAJOR.MINOR.PATCH format, incrementing as follows:

1. The MAJOR version is incremented when an incompatible or breaking API change is introduced.
2. The MINOR version is incremented when backwards-compatible functionality is added.
3. The PATCH version is incremented when backwards-compatible bugs are fixed.

For more information on MAJOR, MINOR, and PATCH versions, and how to evolve API versions, refer to [API Versioning](https://lf-camaraproject.atlassian.net/wiki/x/3yLe) in the CAMARA wiki.

It is recommended to avoid breaking backward compatibility unless strictly necessary; new versions should be backwards compatible with previous versions. For guidance on how to avoid breaking changes, see below.


### API Version in URL (OAS Servers Object)

The OAS file specifies the API version used in the URL of the API within the `servers` object.

The API version in the `url` field includes only the "x" (major version) number of the API version, as shown in the following example:

```yaml
servers:
  url: {apiRoot}/qod/v2
```

**Important Note:** For CAMARA public APIs with a major version of 0 (`v0.x.y`), both the major and minor version numbers must be included in the API version in the `url` field, separated by a dot (`.`). This is represented as `v0.y`, as demonstrated in the following example:

```yaml
servers:
  url: {apiRoot}/number-verification/v0.3
```

This approach allows for both testing and commercial use of initial API versions, which are subject to rapid evolution, such as `/qod/v0.10alpha1`, `/qod/v0.10rc1`, or `/qod/v0.10`. However, it is essential to acknowledge that initial API versions may change over time.



### API Versions throughout the Release Process

In preparation for its public release, an API will go through various intermediate versions indicated by version extensions: alpha and release-candidate.

Overall, an API can have any of the following versions:

* Work-in-progress (`wip`) API versions are used during the development of an API before the first pre-release or in between pre-releases. These versions cannot be released and are not usable by API consumers.
* Alpha (`x.y.z-alpha.m`) API versions, with extensions, are used for CAMARA internal API rapid development purposes.
* Release-candidate (`x.y.z-rc.n`) API versions, with extensions, are used for CAMARA internal API release bug fixing purposes.
* Public (`x.y.z`) API versions are used in commercial contexts. These API versions only have API version number `x.y.z` (semver 2.0), with no extension. Public APIs can have one of two maturity states (used in release management):
  * Initial - indicating that the API is still not fully stable (`x=0`)
  * Stable - indicating that the API has reached a certain level of maturity (`x>0`)

The following table gives the values of the API version (Info object) and the API version in the URL used in the different API version types created during the API release process. For public API versions, this information is also dependent on whether it is an initial (`x=0`) or a stable public API version (`x>0`).

| API Version Type  |  API Version  | Initial (`x=0`) API Version in URL | Stable (`x>0`) API Version in URL | API Version Can Be Released |
|-------------------|:-------------:|:--------------------------------:|:-------------------------------:|:---------------------------:|
| Work-in-progress  |      wip      |               vwip               |              vwip               |             No              |
| Alpha             | x.y.z-alpha.m |            v0.yalpham            |            vxalpham             | Yes (internal pre-release)  |
| Release-candidate |   x.y.z-rc.n  |             v0.yrcn              |              vxrcn              | Yes (internal pre-release)  |
| Public            |     x.y.z     |               v0.y               |               vx                |             Yes             |

Precedence Examples:

* 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1 < 3.0.0.
* 0.1.0 < 0.2.0-alpha.1 < 0.2.0-alpha.2 < 0.2.0-rc.1 < 0.2.0-rc.2 < 0.2.0 (initial public API version)
* 1.0.0 < 1.1.0-alpha.1 < 1.1.0-alpha.2 < 1.1.0-rc.1 < 1.1.0-rc.2 < 1.1.0 (stable public API version)

For more information, please see [API Versioning](https://lf-camaraproject.atlassian.net/wiki/x/3yLe) in the Release Management project wiki.



### Backward and Forward Compatibility

Avoid breaking backward compatibility, unless strictly necessary, which means that new versions should be compatible with previous versions.

When considering that APIs are continually evolving and certain operations will no longer be supported, the following considerations must be taken into account:

* Agree to discontinue an API version with consumers.
* Establish the obsolescence of the API in a reasonable period (6 months).
* Monitor the use of deprecated APIs.
* Remove deprecated APIs documentation.
* Never start using already deprecated APIs.

Types of Modification:

* Not all API changes have an impact on API consumers. These are referred to as backward compatible changes.
* In case of such changes, the update produces a new API version that increases the MINOR or PATCH version number.
* The update can be deployed transparently as it does not change the endpoint of the API, which only contains the MAJOR version number, and all previously existing behavior shall remain the same.
* API consumers shall be notified of the new version availability so that they can take it into account.

Backward Compatible Changes to an API that **DO NOT** Affect Consumers:

* Adding a new endpoint
* Adding new operations on a resource (`PUT`, `POST`, etc.).
* Adding optional input parameters to requests on existing resources. For example, adding a new filter parameter in a GET on a collection of resources.
* Changing an input parameter from mandatory to optional. For example: when creating a resource, a property of said resource that was previously mandatory becomes optional.
* Adding new properties in the representation of a resource returned by the server. For example, adding a new age field to a Person resource, which originally was made up of nationality and name.

Breaking Changes to an API that **DO** Affect Consumers:

* Deleting operations or actions on a resource. For example: POST requests on a resource are no longer accepted.
* Adding new mandatory input parameters. For example: now, to register a resource, a new required field must be sent in the body of the request.
* Modifying or removing an endpoint (breaks existing queries)
* Changing input parameters from optional to mandatory. For example: when creating a Person resource, the age field, which was previously optional, is now mandatory.
* Modifying or removing a mandatory parameter in existing operations (resource verbs). For example, when consulting a resource, a certain field is no longer returned. Another example: a field that was previously a string is now numeric.
* Modifying or adding new responses to existing operations. For example: creating a resource can return a 412 response code.

Compatibility Management:

To ensure this compatibility, the following guidelines must be applied.

**As API Provider**:
* Never change an endpoint name; instead, add a new one and mark the original one for deprecation in a MINOR change and remove it in a later MAJOR change (see semver FAQ entry: https://semver.org/#how-should-i-handle-deprecating-functionality)
* If possible, do the same for attributes
* New fields should always be added as optional.
* Postel's Law: “Be conservative in what you do, be liberal in what you accept from others.” When you have input fields that need to be removed, mark them as unused, so they can be ignored.
* Do not change the field’s semantics.
* Do not change the field’s order.
* Do not change the validation rules of the request fields to more restrictive ones.
* If you use collections that can be returned with no content, then answer with an empty collection and not null.
* Layout pagination support from the start.

Make the information available:
* Provide access to the new API version definition file (via a link or dedicated endpoint)
* If possible, do the same to get the currently implemented API version definition file

**As API Consumer**:
* Tolerant reader: if it does not recognize a field when faced with a response from a service, do not process it, but record it through the log (or resend it if applicable).
* Ignore fields with null values.
* Variable order rule: DO NOT rely on the order in which data appears in responses from the JSON service, unless the service explicitly specifies it.
* Clients MUST NOT transmit personally identifiable information (PII) parameters in the URL. If necessary, use headers.



## Error Responses

To ensure interoperability, it is crucial to implement error management that strictly adheres to the error codes defined in the HTTP protocol.

An error representation must be consistent with the representation of any resource. A primary error message is defined with a JSON structure that includes the following fields:

- A field "status", which can be identified in the response as a standard code from the list of HTTP response status codes.
- A unique error "code", which can be identified and traced for more details. It must be human-readable and not a numeric code. To facilitate error location, you can reference the value or field causing it and include it in the message.
- A detailed description in "message" - in the API specification, it is recommended to use English, but it can be changed to other languages in implementation if needed.

All these fields are mandatory in Error Responses. The "status" and "code" fields have a normative nature, and their use must be standardized (see Section 6.1). On the other hand, "message" is informative.

Fields "status" and "code" values are normative, as defined in CAMARA_common.yaml.

A proposed JSON error structure is shown below:

```json
{
   "status": 400,
   "code": "INVALID_ARGUMENT",
   "message": "A human-readable description of what the event represents"
}
```

In error handling, various cases must be considered, including the possibility of modifying the error message returned to the API consumer. Two possible alternatives for error handling are:

- Error handling done with custom policies in the API admin tool.
- Error management performed in a service queried by the API.

The essential requirements to consider are:

- Error handling should be centralized in a single place.
- Customization of the generated error based on the error content returned by the final core service should be considered.
- Latency in error management should be minimized.

> _NOTE: When standardized AuthN/AuthZ flows are used, please refer to 10.2 Security Implementation and 11.6 Security Definition. The format and content of Error Response for those procedures SHALL follow the guidelines of those standards.



### Standardized use of CAMARA error responses

This section aims to provide a common use of the fields `status` and `code` across CAMARA APIs.

This document elaborates on the existing client errors, identifying different error codes and grouping them into separate tables based on their nature:

* Syntax exceptions
* Service exceptions
* Server errors

#### Syntax Exceptions

| Error status | Error code | Message example | Scope/description |
|--------------|------------|-----------------|--------------------|
| 400          | INVALID_ARGUMENT | Client specified an invalid argument, request body, or query param. | Generic syntax exception |
| 400          | {{SPECIFIC_CODE}} | {{SPECIFIC_CODE_MESSAGE}} | Specific syntax exception regarding a field relevant in the context of the API |
| 400          | OUT_OF_RANGE | Client specified an invalid range. | Specific syntax exception used when a given field has a pre-defined range or an invalid filter criteria combination is requested |
| 403          | PERMISSION_DENIED | Client does not have sufficient permissions to perform this action. | OAuth2 token access does not have the required scope or when the user fails operational security |
| 403          | INVALID_TOKEN_CONTEXT | {{field}} is not consistent with access token. | Reflect some inconsistency between information in some field of the API and the related OAuth2 Token |
| 409          | ABORTED | Concurrency conflict. | Concurrency of processes of the same nature/scope |
| 409          | ALREADY_EXISTS | The resource that a client tried to create already exists. | Trying to create an existing resource |
| 409          | CONFLICT | A specified resource duplicate entry found. | Duplication of an existing resource |
| 409          | {{SPECIFIC_CODE}} | {{SPECIFIC_CODE_MESSAGE}} | Specific conflict situation that is relevant in the context of the API |

#### Service Exceptions

| Error status | Error code | Message example | Scope/description |
|--------------|------------|-----------------|--------------------|
| 401          | UNAUTHENTICATED | Request not authenticated due to missing, invalid, or expired credentials. | Request cannot be authenticated |
| 401          | AUTHENTICATION_REQUIRED | New authentication is required. | New authentication is needed, authentication is no longer valid |
| 403          | {{SPECIFIC_CODE}} | {{SPECIFIC_CODE_MESSAGE}} | Indicate a business logic condition that forbids a process not attached to a specific field in the context of the API |
| 404          | NOT_FOUND | The specified resource is not found. | Resource is not found |
| 404          | IDENTIFIER_NOT_FOUND | Device identifier not found. | Some identifier cannot be matched to a device |
| 404          | {{SPECIFIC_CODE}} | {{SPECIFIC_CODE_MESSAGE}} | Specific situation to highlight the resource/concept not found |
| 422          | UNSUPPORTED_IDENTIFIER | The identifier provided is not supported. | None of the provided identifiers is supported by the implementation |
| 422          | IDENTIFIER_MISMATCH | Provided identifiers are not consistent. | Inconsistency between identifiers not pointing to the same device |
| 422          | UNNECESSARY_IDENTIFIER | The device is already identified by the access token. | An explicit identifier is provided when a device or phone number has already been identified from the access token |
| 422          | SERVICE_NOT_APPLICABLE | The service is not available for the provided identifier. | Service not applicable for the provided identifier |
| 422          | MISSING_IDENTIFIER | The device cannot be identified. | An identifier is not included in the request and the device or phone number identification cannot be derived from the 3-legged access token |
| 422          | {{SPECIFIC_CODE}} | {{SPECIFIC_CODE_MESSAGE}} | Any semantic condition associated to business logic, specifically related to a field or data structure |
| 429          | QUOTA_EXCEEDED | Out of resource quota. | Request is rejected due to exceeding a business quota limit |
| 429          | TOO_MANY_REQUESTS | Rate limit reached. | Access to the API has been temporarily blocked due to rate or spike arrest limits being reached |

#### Server Exceptions

| Error status | Error code | Message example | Scope/description |
|--------------|------------|-----------------|--------------------|
| 405          | METHOD_NOT_ALLOWED | The requested method is not allowed/supported on the target resource. | Invalid HTTP verb used with a given endpoint |
| 406          | NOT_ACCEPTABLE | The server cannot produce a response matching the content requested by the client through Accept-* headers. | API Server does not accept the media type (Accept-* header) indicated by API client |
| 410          | GONE | Access to the target resource is no longer available. | Use in notifications flow to allow API Consumer to indicate that its callback is no longer available |
| 412          | FAILED_PRECONDITION | Request cannot be executed in the current system state. | Indication by the API Server that the request cannot be processed in current system state |
| 415          | UNSUPPORTED_MEDIA_TYPE | The server refuses to accept the request because the payload format is in an unsupported format. | Payload format of the request is in an unsupported format by the Server |
| 500          | INTERNAL | Unknown server error. Typically a server bug. | Problem in Server side |
| 501          | NOT_IMPLEMENTED | This functionality is not implemented yet. | Service not implemented. The use of this code should be avoided as far as possible to get the objective to reach aligned implementations |
| 502          | BAD_GATEWAY | An upstream internal service cannot be reached. | Internal routing problem in the Server side that blocks to manage the service properly |
| 503          | UNAVAILABLE | Service Unavailable. | Service is not available. Temporary situation usually related to maintenance process in the server side |
| 504          | TIMEOUT | Request timeout exceeded. | API Server Timeout |

**Mandatory Errors** to be **documented in CAMARA API Spec YAML** are the following:

* For event subscriptions APIs, the ones defined in [12.1 Subscription](#error-definition-for-resource-based-explicit-subscription)
* For event notifications flow, the ones defined in [12.2 Event notification](#error-definition-for-event-notification)
* For the rest of APIs:
	+ Error status 401
	+ Error status 403

NOTE:
The documentation of non-mandatory error statuses defined in section 6.1 depends on the specific considerations and design of the given API.
* Error statuses 400, 404, 409, 422, 429: These error statuses should be documented based on the API design and the functionality involved. Subprojects evaluate the relevance and necessity of including these statuses in API specifications.
* Error statuses 405, 406, 410, 412, 415, and 5xx: These error statuses are not documented by default in the API specification. However, they should be included if there is a relevant use case that justifies their documentation.
	+ Special Consideration for error 501 NOT IMPLEMENTED to indicate optional endpoint:
		- The use of optional endpoints is discouraged in order to have aligned implementations
		- Only for exceptions where an optional endpoint cannot be avoided and defining it in separate, atomic API is not possible - error status 501 should be documented as a valid response



### Error Responses - Device Object/Phone Number

This section outlines guidelines for error responses related to the `device` object or `phoneNumber` field.

The following table summarizes the guidelines to be adopted:

| Case # | Description | Error status | Error code | Message example |
|:-------|:------------|:-------------|:-----------|:----------------|
| 0      | Request body does not comply with the schema | 400 | INVALID_ARGUMENT | Request body does not comply with the schema. |
| 1      | None of the provided identifiers is supported by the implementation | 422 | UNSUPPORTED_IDENTIFIER | The identifier provided is not supported. |
| 2      | Some identifier cannot be matched to a device | 404 | IDENTIFIER_NOT_FOUND | Device identifier not found. |
| 3      | Inconsistency between identifiers not pointing to the same device | 422 | IDENTIFIER_MISMATCH | Provided identifiers are not consistent. |
| 4      | An explicit identifier is provided when a device or phone number has already been identified from the access token | 422 | UNNECESSARY_IDENTIFIER | The device is already identified by the access token. |
| 5      | Service not applicable for the provided identifier | 422 | SERVICE_NOT_APPLICABLE | The service is not available for the provided identifier. |
| 6      | An identifier is not included in the request and the device or phone number identification cannot be derived from the 3-legged access token | 422 | MISSING_IDENTIFIER | The device cannot be identified. |


Templates are reusable pieces of code that can be used to generate new documents, emails, or other types of content. They provide a starting point for creating new content, saving time and effort by eliminating the need to start from scratch.

Templates can be used in a variety of contexts, including:

* Document creation: Templates can be used to generate new documents, such as reports, proposals, or presentations.
* Email creation: Templates can be used to generate new emails, such as newsletters or promotional emails.
* Content creation: Templates can be used to generate new content, such as blog posts or social media posts.

The benefits of using templates include:

* Increased productivity: Templates save time and effort by providing a starting point for creating new content.
* Consistency: Templates ensure that content is consistent in terms of format and style.
* Reduced errors: Templates help to reduce errors by providing a standardized format for content.

When choosing a template, consider the following factors:

* Purpose: What is the purpose of the template? Is it for document creation, email creation, or content creation?
* Audience: Who is the template for? Is it for internal use or external use?
* Format: What is the format of the template? Is it a word document, a presentation, or an email?
* Style: What is the style of the template? Is it formal or informal?

By choosing the right template and using it effectively, you can save time, increase productivity, and ensure consistency in your content.



Here is the enhanced version of the provided text:

A response template groups all examples for the same operation and status code.

The schema is common for all errors.

```yaml
description: |
  The examples section includes a list of subcases for this status error code to be implemented. In each example, `status` and `code` are normative for the specific error case, while `message` may be adjusted or localized by the implementation.
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
        $ref: "#/components/examples/{{case_1}}"
      {{case_2}}:
        $ref: "#/components/examples/{{case_2}}"
```



Here is the enhanced version of the template:

```yaml
components:
  examples:
    {{case_N}}:
      summary: {{Description}}
      description: {{Detailed description of the example}}
      value:
        status: {{Error status}}
        code: {{Error code}}
        message: {{Example error message}}
```



## Data

Data is a collection of facts, statistics, or information that can be used for analysis, interpretation, or decision-making. It can be in the form of numbers, text, images, or other types of media.

Data can be categorized into two main types: qualitative and quantitative. Qualitative data refers to non-numerical information, such as text, images, or videos, that provides context and insight into a particular topic or issue. Quantitative data, on the other hand, refers to numerical information that can be measured and analyzed statistically.

Data is used in various fields, including business, science, engineering, and social sciences. It is used to identify trends, patterns, and correlations, and to make informed decisions based on evidence. Data can also be used to predict future outcomes, optimize processes, and improve performance.

Data can be collected from various sources, including surveys, experiments, observations, and existing databases. It can be stored in various formats, such as spreadsheets, databases, or data warehouses.

Data analysis is the process of extracting insights and meaning from data. It involves using statistical and mathematical techniques to identify patterns, trends, and correlations in the data. Data analysis can be performed using various tools and techniques, including data visualization, machine learning, and statistical modeling.

Data visualization is the process of representing data in a graphical format to facilitate understanding and interpretation. It involves using charts, graphs, and other visualizations to communicate complex data insights to stakeholders.

Data security is a critical aspect of data management. It involves protecting data from unauthorized access, theft, or damage. Data security measures include encryption, access controls, and backup and recovery procedures.

Data management is the process of planning, organizing, and maintaining data to ensure its quality, accuracy, and availability. It involves creating data standards, defining data structures, and implementing data governance policies.

Data governance is the process of defining and enforcing policies and procedures for data management. It involves establishing data ownership, defining data quality standards, and implementing data security measures.


### Common Data Types

This clause outlines the standard data types that will be used consistently across all definitions, ensuring they meet the necessary information requirements.

Note that this section is subject to ongoing evolution over time, allowing for the introduction of new data structures as needed. To facilitate effective management of this dynamic list, an external repository has been established.

The repository, referenced below, serves as a centralized source for this information.

[Link to Common Data Types documentation repository](../artifacts/CAMARA_common.yaml)



### Data Definitions

This section captures a detailed description of all the data structures used in the API specification. For each of these data, the specification must include:
- The name of the data object, used to reference it in other sections.
- The data type (String, Integer, Object…).
- If the data type is a string, it is recommended to use an appropriate modifier property `format` and/or `pattern` whenever possible. The OpenAPI Initiative Formats Registry contains the list of formats used in OpenAPI specifications.
  - If the format of a string is `date-time`, the description must include the following sentence: "It must follow RFC 3339 and must have a time zone. The recommended format is yyyy-MM-dd'T'HH:mm:ss.SSSZ (i.e. which allows 2023-07-03T14:27:08.312+02:00 or 2023-07-03T12:27:08.312Z)"
- If the data type is an object, a list of required properties.
- A list of properties within the object data, including:
   - Property name
   - Property description
   - Property type (String, Integer, Object …)
   - Other properties by type:
      - String properties: minimum and maximum length
      - Integer properties: Format (int32, int64…), minimum value.

In this section, the error response structure must also be defined following the guidelines in [Chapter 6. Error Responses](#6-error-responses).



#### Usage of Discriminator

As mentioned in the OpenAPI documentation [here](https://spec.openapis.org/oas/v3.0.3#discriminator-object), using a discriminator can simplify the serialization and deserialization process, ultimately reducing resource consumption.



Inheritance

The mappings section in a discriminator is not mandatory; by default, Class Names are used as values to populate the property. You can use mappings to restrict usage to a subset of subclasses.

When possible, use the Object Name as a key in the mapping section. This simplifies the work of providers and consumers who use OpenAPI code generators.

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
            - Object Name: '#/components/schemas/Object Name'  # use Object Name as mapping key to simplify usage
            - Object Name: '#/components/schemas/Object Name'

    Ipv4Addr:  # Object Name also known as Class Name, used as JsonName by OpenAPI generator
      allOf:  # extends IpAddr (no need to define addressType because it's inherited
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
      allOf:  # extends IpAddr
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



Polymorphism
------------

To facilitate usage of a Camera object from strongly typed languages, it is generally recommended to use inheritance over polymorphism. However, if polymorphism is unavoidable, adhere to the following guidelines:

*   Objects containing a `oneOf` or `anyOf` section must include a discriminator defined by a `propertyName`.
*   Objects involved in a `oneOf` or `anyOf` section must include a property designated by `propertyName`.

The following example illustrates this usage:

```yaml
IpAddr:
  oneOf:
    - $ref: '#/components/schemas/Ipv6Addr'
    - $ref: '#/components/schemas/Ipv4Addr'
  discriminator:
    propertyName: objectType  # objectType property must be present in the objects referenced in oneOf

Ipv4Addr:  # object involved in oneOf must include the objectType property
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

Ipv6Addr:  # object involved in oneOf must include the objectType property
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

When `IpAddr` is used in a payload, the `objectType` property must be present to indicate which schema to use:

```json
{
  "ipAddr": {
    "objectType": "Ipv4Addr",  # objectType indicates to use Ipv4Addr to deserialize this IpAddr
    "address": "192.168.1.1",
    ...
  }
}
```



## Pagination, Sorting, and Filtering

Exposing a resource collection through a single URI can lead to inefficient data retrieval, as applications often fetch large amounts of data when only a subset is needed. For instance, consider a client application seeking all orders with a cost exceeding a specific value. In this case, retrieving all orders from the /orders URI and then filtering them on the client side is a highly inefficient process. It unnecessarily consumes network bandwidth and processing power on the server hosting the web API.

To address these issues, the API provider may optionally support Pagination, Sorting, and Filtering. The following subsections apply when such functionality is supported.



### Pagination

Services can return a resource or article collection. In some cases, these collections may be partial due to performance or security reasons. Elements must be consistently identified and arranged on all pages. Enabling paging on the server side by default can help mitigate denial of service or similar attacks.

When paging is supported, services must accept and use these query parameters:

- `perPage`: the number of resources requested in the response
- `page`: the requested page number, indicating the start of resources to be provided in the response (considering `perPage` page size)
- `seek`: the index of the last result read, used for pagination in systems with more than 1000 records. The `seek` parameter offers finer control than `page` and can be used as an alternative. If both are used together (not recommended), `seek` marks the index starting from the page number specified by `page` and `perPage` [index = (page * perPage) + seek].

Services must also accept and use these headers when paging is supported:

- `Content-Last-Key`: allows specifying the key of the last resort provided in the response
- `X-Total-Count`: indicates the total number of elements in the collection

If the server cannot meet any of the required parameters, it should return an error message.

The HTTP codes used as responses are:

- `200`: the response includes the complete list of resources
- `206`: the response does not include the complete list of resources
- `400`: request outside the range of the resource list

Petition examples:

- `page=0 perPage=20`, which returns the first 20 resources
- `page=10 perPage=20`, which returns 20 resources from the 10th page (starting at the 200th position, as 10 x 20 = 200)



### Sorting


Sorting the result of a query on a resource collection requires two primary parameters:

Note: Services must accept and use these parameters when sorting is supported. If a parameter is not supported, the service should return an error message.

- `orderBy`: This parameter contains the names of the attributes on which the sort is performed, separated by commas if there are multiple criteria.
- `order`: By default, sorting is done in descending order. To specify the sort criteria, use "asc" or "desc" as the query value.

For example, to retrieve the list of orders sorted by rating, reviews, and name in descending order, use the following query:

```http
https://api.mycompany.com/v1/orders?orderBy=rating,reviews,name&order=desc
```



### Filtering

Filtering involves limiting the number of resources retrieved by specifying certain attributes and their expected values. This allows for filtering multiple attributes simultaneously and supporting multiple values for a single filtered attribute.

The filtering process is further refined based on the type of data being searched, including numbers and dates, and the type of operation. Note that services may not support all attributes for filtering. If a query includes an attribute for which filtering is not supported, it may be ignored by the service.



#### Filtering Security Considerations

When filtering data, it's essential to consider privacy and security constraints to avoid revealing sensitive information. This includes defining query parameters that prevent users from filtering by personal details, such as names, phone numbers, or IP addresses.



#### Filtering Operations

| **Operation**     | 	Numbers                     | 	Dates                                        |
|-------------------|------------------------------|-----------------------------------------------|
| Equal             | `GET .../?amount=807.24`	    | `GET .../?executionDate=2024-02-05T09:38:24Z` |
| Greater or equal	 | `GET .../?amount.gte=807.24` | `GET.../?executionDate.gte=2018-05-30`        |
| Strictly greater  | `GET .../?amount.gt=807.24`  | `GET.../?executionDate.gt=2018-05-30`         |
| Smaller or equal	 | `GET .../?amount.lte=807.24` | `GET.../?executionDate.lte=2018-05-30`        |
| Strictly smaller  | `GET .../?amount.lt=807.24`  | `GET.../?executionDate.lt=2018-05-30`         |

According to the filtering based on string and enums data, being searched for:

| **Operation** |	**Strings/enums** |
| ----- | ----- |
| Equal | `GET .../?type=mobile` |
| Non equal | `GET .../?type!=mobile` |
| Contains | `GET .../?type=~str` |

For boolean parameters, the filter can be set for True or False value:

| **Operation** | 	**Booleans**    |
|---------------|-----------------------|
| True          | `GET .../?boolAttr=true`  |
| False         | `GET .../?boolAttr=false` |

**Additional Rules:**

- The operator "`&`" is evaluated as an AND between different attributes.
- A Query Param (attribute) can contain one or n values separated by "`,`".
- For operations on numeric, date, or enumerated fields, the parameters with the suffixes `.(gte|gt|lte|lt)$` need to be defined, which should be used as comparators for “greater or equal to, greater than, smaller or equal to, smaller than” respectively. Only the parameters needed for the given field should be defined, e.g., with `.gte` and `.lte` suffixes only.

**Examples:**

- **Equals**: to search devices with a particular operating system and version or type:
  - `GET /device?os=ios&version=17.0.1`
  - `GET /device?type=apple,android`
    - Search for several values separating them by "`,`".
- **Inclusion**: if we already have a filter that searches for "equal" and we want to provide it with the possibility of searching for "inclusion," we must include the character "~"
  - `GET /device?version=17.0.1`
    - Search for the exact version "17.0.1"
  - `GET /device?version=~17.0`
    - Look for version strings that include "17.0"
- **Greater than / less than**: new attributes need to be created with the suffixes `.(gte|gt|lte|lt)$` and included in `get` operation:

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
      name: creationDate.gte    <-- query attribute for "greater or equal to" comparison 
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


## Security

Good practices to secure REST APIs

The following points can serve as a checklist to design the security mechanism of the REST APIs.

1. **Simple and Targeted Security**. 
   Only secure the APIs that require it, as overly complex solutions can introduce vulnerabilities. 
   Prioritize simplicity to minimize potential security risks.

2. **Mandatory HTTPS**. 
   TLS ensures the confidentiality of data and verifies the server's identity. 
   When using HTTP/2 for performance improvements, multiple requests can be sent over a single connection, reducing overhead.

3. **Hashed Passwords**. 
   Never send passwords in API bodies, and if necessary, hash them to protect against compromise. 
   Effective hashing algorithms include PBKDF2, bcrypt, and scrypt.

4. **URL Security**. 
   Avoid exposing sensitive information like usernames, passwords, session tokens, and API keys in URLs. 
   This can be captured in web server logs, making them vulnerable to exploitation. 
   For example, the URL `https://api.domain.com/user-management/users/{id}/someAction?apiKey=abcd123456789` exposes the API key.

5. **Authentication and Authorization**. 
   Implement authentication and authorization protocols as described in the Camara Security and Interoperability Profile. 
   This profile outlines the necessary protocols and flows for secure authentication and authorization.

6. **Request Time Flags**. 
   Consider adding a request timestamp as a custom HTTP header in API requests. 
   The server will compare the current timestamp with the request timestamp and only accept the request if it falls within a reasonable time frame (e.g., 1-2 minutes). 
   This prevents basic replay attacks where the attacker attempts to reuse a request without modifying the timestamp.

7. **Parameter Validation**. 
   Validate request parameters in the first step before reaching application logic. 
   Implement strong validation checks and reject the request immediately if validation fails. 
   In the API response, provide relevant error messages and an example of the correct input format to enhance user experience.


### Security Definition

To ensure that only authorized individuals have access to specific data and functionalities, all APIs must be secured. This involves controlling who has access to what and for what purpose.

Camara relies on OIDC and CIBA for authentication and consent collection, enabling the system to determine whether a user has opted out of certain API access.

The [Camara Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md#purpose) specifies that a single purpose is encoded in the list of scope values. The purpose values are defined by the W3C Data Privacy Vocabulary, as outlined in the [Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md#purpose-as-a-scope).



### Expressing Security Requirements

Security requirements of an API are expressed in OpenAPI through Security Requirement Objects, as defined in the OpenAPI Specification.

To use the `openId` security scheme, follow the example described in the Use of security property section. The security scheme is defined as follows:

```yaml
paths:
  {path}:
    {method}:
      ...
      security:
        - openId:
            - {scope}
```

Note that the `openId` name must match the security scheme defined in the `components.securitySchemes` section.



### Mandatory template for `info.description` in CAMARA API specs

The documentation template available in [CAMARA API Specification - Authorization and authentication common guidelines](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#mandatory-template-for-infodescription-in-camara-api-specs) must be used when creating the authorization and authentication API documentation for the `info.description` property in the CAMARA API specs.



### Scope Naming

Scope names should be concise and descriptive, ideally no longer than a few words. They should clearly convey the purpose or function of the scope, making it easy for others to understand its intended use.

When choosing a scope name, consider the following guidelines:

*   Use a consistent naming convention throughout the project.
*   Avoid using acronyms or abbreviations unless they are widely recognized.
*   Use words that are easy to understand and remember.
*   Keep the name concise, but not so short that it loses meaning.
*   Use a verb or action word to indicate what the scope does.



#### APIs without Explicit Subscriptions

For APIs that do not involve explicit subscriptions, the guidelines for scope naming are as follows:

* Define a scope per API operation with the structure `api-name:[resource:]action`, where:
  * `api-name` is the API name, taken from the base path before the API version, as specified in the `servers[*].url` property. For example, from `/location-verification/v0`, it would be `location-verification`.
  * `resource` is optional and may include the resource in the path for APIs with multiple paths. For instance, from `/qod/v0/sessions/{sessionId}`, it would be `sessions`.
  * `action` has two cases:
    - For POST operations with a verb, it will be the verb itself. For example, from `POST /location-verification/v0/verify`, it would be `verify`.
      - For endpoints designed as POST but with underlying logic retrieving information, a CRUD action `read` may be added. However, if it's a path with a single operation and no additional operations are expected, the CRUD action is not necessary.
    - For CRUD operations on a resource in paths, it will be one of:
      - `create`: For operations creating the resource, typically `POST`.
      - `read`: For operations accessing details of the resource, typically `GET`.
      - `update`: For operations modifying the resource, typically `PUT` or `PATCH`.
      - `delete`: For operations removing the resource, typically `DELETE`.
      - `write`: For operations creating or modifying the resource when differentiation between `create` and `update` is not needed.

* It's possible that we may need to add an additional level to the scope, such as `api-name:[resource:]action[:detail]`, to handle cases where only a subset of parameters or information needs to be allowed for return. Guidelines will be enhanced when such cases arise.



##### Examples

| API                   | path          | method | scope                                             |
|-----------------------|---------------|--------|---------------------------------------------------|
| location-verification | /verify       | POST   | location-verification:verify                     |
| qod                   | /sessions     | POST   | qod:sessions:create, or qod:sessions:write        |
| qod                   | /qos-profiles | GET    | qod:qos-profiles:read                             |


#### API-level Scopes

The decision on API-level scopes was made within the Identity and Consent Management Working Group and is documented in the design guidelines to ensure the completeness of this document. API-level scopes are defined in the API Specs YAML files, which means a scope will only provide access to all endpoints and resources of an API if it is explicitly defined in the API Spec YAML file and agreed upon in the corresponding API subproject.



## OAS Sections

The OpenAPI Specification (OAS) is a widely adopted standard for describing RESTful APIs. It is used to define the structure of an API, including the available endpoints, request and response formats, and authentication mechanisms.

The OAS specification is divided into several sections, each serving a specific purpose:

* **Paths**: This section defines the API endpoints and their corresponding HTTP methods. It includes information such as the endpoint URL, HTTP method, request body, and response format.
* **Parameters**: This section defines the parameters that can be passed to the API endpoints, including query parameters, path parameters, and header parameters.
* **Responses**: This section defines the possible responses that can be returned by the API endpoints, including the response code, response body, and headers.
* **Security**: This section defines the authentication and authorization mechanisms used by the API, including OAuth, API keys, and basic authentication.
* **Tags**: This section allows users to categorize and group API endpoints based on their functionality or purpose.
* **External Documentation**: This section provides a link to external documentation that provides more information about the API.

Each section is essential in providing a comprehensive understanding of the API's functionality and behavior. By defining the API's structure and behavior in a standardized way, the OAS specification enables developers to easily understand and interact with the API.


### OpenAPI Version
APIs must use the OpenAPI Specification (OAS) version 3.0.3.



### Info Object

The `info` object must contain the following content:

```yaml
info:
  # API title without "API" in it, e.g. "Number Verification"
  title: Number Verification
  # API description explaining the API, part of the API documentation
  description: |
    This API verifies that the provided mobile phone number matches the one used in the device.
    It checks that the user is using a device with the same mobile phone number as declared.
  # Authorization and authentication guidelines
  description: |
    For more information on authorization and authentication, see section 11.6.
  # API version - Aligned to SemVer 2.0 according to CAMARA versioning guidelines
  version: 1.0.1
  # Name of the license and a URL to the license description
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html
  # CAMARA Commonalities minor version - x.y
  x-camara-commonalities: 0.5
```

The `termsOfService` and `contact` fields are optional in the OpenAPI specification and may be added by API providers documenting their APIs.

The extension field `x-camara-commonalities` indicates the minor version of CAMARA Commonalities guidelines that the given API specification adheres to.

An example of the `info` object is shown below:

```yaml
info:
  title: Number Verification
  description: |
    This API verifies that the provided mobile phone number matches the one used in the device.
    It checks that the user is using a device with the same mobile phone number as declared.
  version: 1.0.1
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html
  x-camara-commonalities: 0.4.0
```


#### Title
This title provides a brief overview of the service. It should be concise and to the point, avoiding the use of the term "API".


No special restrictions are specified in Camara.



APIs shall use the versioning format as specified by the release management working group, as outlined in the [versioning-format](https://lf-camaraproject.atlassian.net/wiki/x/3yLe).



Terms of service should not be included. API providers may add this content when documenting their APIs.


Contact information should not be included. API providers may choose to add this content when documenting their APIs.


#### License
The license object should contain the following fields:
```
license
  name: Apache 2.0
  url: https://www.apache.org/licenses/LICENSE-2.0.html
```



#### Extension Field
The API shall specify the commonalities release number to which they are compliant by including the x-camara-commonalities extension field.



### Servers Object

The `servers` object must contain the following information:

```yaml
servers:
  # apiRoot variable and the fixed base path containing <api-name> and <api-version> as defined in chapter 5  
  - url: "{apiRoot}/quality-on-demand/v2"
    variables:
      apiRoot:
        default: "http://localhost:9091"
        description: "API root, defined by the service provider, e.g. `api.example.com` or `api.example.com/somepath`"
```

If multiple server objects are listed, each instance's `servers[*].url` property must have the same string for `api-name` and `api-version`.

The servers object must have the following content:

```yaml
servers:
  - url: "{apiRoot}/<api-name>/<api-version>"
    variables:
      apiRoot:
        default: "http://localhost:9091"
        description: "API root, defined by the service provider, e.g. `api.example.com` or `api.example.com/somepath`"
```


#### API-Name
The API name is the base path specified before the API version in the `servers[*].url` property. When multiple server objects are listed, each `servers[*].url` property must contain the same string for the API name and version.

For example, in the following URL, the API name would be "location-verification".
 
 /location-verification/v0



#### API-Version

The API-version should match the [Version](#version) specified in the info object.


### Paths
No special restrictions or changes are specified in Camara.


Tags are a fundamental concept in many applications, including databases, content management systems, and social media platforms. They enable users to categorize and organize information, making it easier to search, filter, and retrieve relevant data.

In a database context, tags are often used as a means of indexing and retrieving data. By assigning relevant tags to a record, users can quickly locate information that matches specific criteria. Tags can also be used to create relationships between different pieces of data, facilitating the creation of complex queries and reports.

In content management systems, tags are commonly used to categorize and organize content, such as blog posts, articles, and documents. This enables users to quickly find and access relevant content, and also facilitates the creation of content recommendations and personalized feeds.

In social media platforms, tags are used to identify and connect with other users, as well as to categorize and organize content. By using relevant tags, users can increase the visibility of their posts and connect with others who share similar interests.

Overall, tags play a crucial role in many applications, enabling users to efficiently organize, search, and retrieve information.


### Components

The components are the building blocks of the system. They are self-contained modules that provide a specific functionality. Each component is designed to be modular, reusable, and easily integrable with other components.

Components can be categorized into two main types: **user interface components** and **business logic components**. User interface components are responsible for rendering the visual aspects of the system, such as buttons, forms, and menus. Business logic components, on the other hand, handle the underlying logic and data processing of the system.

Components can be further divided into subcategories based on their functionality, such as:

* **Presentation components**: These components are responsible for rendering the visual aspects of the system, including layout, styling, and user interaction.
* **Service components**: These components provide a specific business function or service, such as authentication, payment processing, or data storage.
* **Utility components**: These components provide general-purpose functionality, such as logging, caching, or error handling.

Components are designed to be loosely coupled, allowing them to be easily replaced or updated without affecting other parts of the system. This modular design enables the system to be scalable, maintainable, and flexible.

Components can be developed using a variety of programming languages and frameworks, including HTML, CSS, JavaScript, and server-side languages like Java, Python, or Ruby. The choice of technology depends on the specific requirements of the project and the skills of the development team.

In summary, components are the fundamental building blocks of the system, providing a modular and reusable approach to software development.


Schemas
--------

Schemas are an essential part of data modeling in databases. They define the structure of the data, including the relationships between different data elements. A well-designed schema can improve data consistency, reduce data redundancy, and enhance data integrity.

In a database, a schema is a set of rules that govern how data is organized and stored. It defines the relationships between different tables, including the types of data that can be stored in each table, the relationships between tables, and the constraints on the data.

There are several types of schemas, including:

*   Entity-relationship (ER) schema: This type of schema represents the relationships between different entities in the database.
*   Relational schema: This type of schema represents the relationships between different tables in the database.
*   Object-relational schema: This type of schema represents the relationships between different objects in the database.

A good schema should be flexible enough to accommodate changing business needs, yet rigid enough to enforce data consistency and integrity. It should also be easy to understand and maintain, with clear and concise definitions of each data element.

In practice, schemas are often implemented using a combination of database design tools and programming languages. The choice of schema depends on the specific requirements of the database and the needs of the users.

Schemas play a critical role in database design and development, and are essential for creating a robust and scalable database system.


When you respond to someone, consider the following:

*   Be clear and concise in your response.
*   Make sure you understand the question or topic being discussed.
*   Provide relevant information or examples to support your answer.
*   Avoid using jargon or technical terms that the other person may not understand.
*   Be respectful and considerate of the other person's feelings and opinions.
*   Proofread your response for spelling and grammar errors before sending it.

By following these guidelines, you can respond effectively and communicate your ideas clearly.

**Parameters**

Parameters are the values that are passed to a function when it is called. They are used to customize the behavior of the function and to provide it with the necessary information to perform its task.

Each parameter has a name and a value. The name is used to identify the parameter, and the value is the actual data that is passed to the function.

In most programming languages, parameters are specified when a function is defined, and they are passed to the function when it is called. The number and types of parameters that a function can accept are determined when the function is defined.

For example, a function that calculates the area of a rectangle might have two parameters: `length` and `width`. When the function is called, the values of `length` and `width` would be passed to the function, and it would use these values to calculate the area.

Parameters are an essential part of programming, as they allow functions to be reusable and flexible. By passing different values to a function, you can customize its behavior and use it to solve a wide range of problems.


Request bodies are the data sent in the body of an HTTP request. They can be used to send additional information to the server, such as form data, JSON data, or multipart/form-data.

There are several types of request bodies:

* **Form data**: This type of request body is used to send data in a URL-encoded format. It is typically used for forms where the data is sent as key-value pairs.
* **JSON data**: This type of request body is used to send data in JSON format. It is typically used for APIs where the data is sent as a JSON object.
* **Multipart/form-data**: This type of request body is used to send files and other binary data. It is typically used for uploading files to a server.

When sending a request body, the Content-Type header must be set to indicate the type of data being sent. For example, if you are sending form data, the Content-Type header should be set to application/x-www-form-urlencoded.

Request bodies can be sent using a variety of methods, including:

* **POST**: This method is typically used to send data to a server to create a new resource.
* **PUT**: This method is typically used to send data to a server to update an existing resource.
* **PATCH**: This method is typically used to send data to a server to partially update an existing resource.

The request body can be sent in a variety of formats, including:

* **URL-encoded**: This format is used to send data in a URL-encoded format.
* **JSON**: This format is used to send data in JSON format.
* **Multipart/form-data**: This format is used to send files and other binary data.

When receiving a request body, the server can access the data using the request object. For example, in Python, you can access the request body using the request.body attribute.


#### Headers

To standardize the request observability and traceability process, common headers that facilitate the tracking of end-to-end processes should be included. The following table outlines these headers.

| Name           | Description                                   | Schema          | Location         | Required by API Consumer | Required in OAS Definition | 	Example                              | 
|----------------|-----------------------------------------------|----------------------|------------------|--------------------------|----------------------------|----------------------------------------|
| `x-correlator` | 	Service correlator for end-to-end observability | `type: string`  `pattern: ^[a-zA-Z0-9-]{0,55}$`     | Request / Response | No                       | Yes                        | 	b4333c46-49c0-4f62-80d7-f0ef930f1c46 |

When the API Consumer includes a non-empty "x-correlator" header in the request, the API Provider must include it in the response with the same value used in the request. Otherwise, it is optional to include the "x-correlator" header in the response with any valid value. It is recommended to use a UUID for values.

In notification scenarios (i.e., POST requests sent towards the listener indicated by `sink` address), the use of the "x-correlator" is supported for the same purpose. When the API request includes the "x-correlator" header, it is recommended for the listener to include it in the response with the same value as was used in the request. Otherwise, it is optional to include the "x-correlator" header in the response with any valid value.

NOTE: HTTP headers are case-insensitive. The use of the naming `x-correlator` is a guideline to align the format across CAMARA APIs.



#### Security Schemes

Security schemes in OpenAPI express security for APIs. Security can be applied to the entire API or to individual endpoints.

As specified in [Use of OpenID Connect for Security Schemes](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#use-of-openidconnect-for-securityschemes), all Camara OpenAPI files must include the following security scheme definition with an adapted `openIdConnectUrl` in the components section. The schema definition is repeated here for illustration purposes; the correct format should be obtained from the link above.

```yaml
components:
  securitySchemes:
    openId:
      type: openIdConnect
      openIdConnectUrl: https://example.com/.well-known/openid-configuration
```

The key of the security scheme is arbitrary in OAS, but convention in CAMARA is to name it `openId`.



### External Documentation

External documentation is any information that is not part of the code itself but is still relevant to understanding, using, or maintaining the software. This can include user manuals, technical guides, API documentation, and other related materials.

External documentation can be provided in various formats, such as HTML, PDF, or Word documents, and can be hosted on the project's website, GitHub repository, or other online platforms. It is essential to keep external documentation up-to-date and accurate to ensure that users and developers have access to the most current information.

Some common types of external documentation include:

*   User manuals: These provide instructions on how to use the software, including its features, functionality, and any specific requirements.
*   Technical guides: These offer more in-depth information on the software's technical aspects, such as its architecture, configuration, and troubleshooting.
*   API documentation: This documentation explains how to interact with the software's API, including the available endpoints, parameters, and response formats.
*   Release notes: These provide information on changes made to the software in each release, including new features, bug fixes, and known issues.

Effective external documentation is crucial for the success of a software project. It helps users understand how to use the software, developers to implement and maintain it, and stakeholders to make informed decisions.

## Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier

## Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier

When an API requires a User (as defined by the [ICM Glossary](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#glossary-of-terms-and-concepts)) to be identified to access their data (as Resource Owner), the User can be identified in one of two ways:
- If the access token is a Three-Legged Access Token, the User will already be associated with that token by the API provider. This association may be made from the physical device that calls the `/authorize` endpoint for the OIDC authorization code flow, or from the `login_hint` parameter of the OIDC CIBA flow (which can be a device IP, phone number, or operator token). The `sub` claim of the ID token returned with the access token confirms the association, although it does not directly identify the User due to the [CAMARA Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md#id-token-sub-claim) requirements.
- If the access token is a Two-Legged Access Token, no User is associated with the token, and an explicit identifier MUST be provided. This is typically a `Device` object named `device`, or a `PhoneNumber` string named `phoneNumber`. Both of these schema are defined in the [CAMARA_common.yaml](/artifacts/CAMARA_common.yaml) artifact. In both cases, it is the User being identified, although the `device` identifier allows this indirectly by identifying an active physical device.

If an API provider issues Three-Legged Access Tokens for use with the API, the following error may occur:
- **Both a Three-Legged Access Token and an explicit User identifier (device or phone number) are provided by the API consumer.**

  Although it might be considered harmless to proceed if both identify the same User, returning an error only when the two do not match allows the API consumer to confirm the identity of the User associated with the access token, which they might otherwise not know. Although this functionality is supported by some APIs (e.g. Number Verification, KYC Match), for others it may exceed the scope consented to by the User.

  If the API scope does not allow explicit confirmation as to whether the identifiers match, a `422 UNNECESSARY_IDENTIFIER` error MUST be returned whether the identifiers match or not.

  If the API scope allows explicit confirmation as to whether the identifiers match, a `403 INVALID_TOKEN_CONTEXT` error MUST be returned if the identifiers do not match and the mismatch is not indicated using some other mechanism (e.g. as an explicit field in the API response body).

If an API provider issues Two-Legged Access Tokens for use with the API, the following error may occur:
- **Neither a Three-legged Access Token nor an explicit User identifier (device or phone number) are provided by the API consumer.**

  One or other MUST be provided to identify the User.

  In this case, a `422 MISSING_IDENTIFIER` error code MUST be returned, indicating that the API provider cannot identify the User from the provided information.

The documentation template below is RECOMMENDED to be used as part of the `info.description` API documentation to explain to the API consumer how the pattern works.

This template is applicable to CAMARA APIs which:
- require the User (i.e. Resource Owner) to be identified; and
- may have implementations which accept Two-Legged Access Tokens; and
- do not allow the API to confirm whether or not the optional User identifier (`device` or `phoneNumber`) matches that associated with the Three-Legged Access Token

The template SHOULD be customised for each API using it by deleting one of the options marked by (*)

```md



# Identifying the Device or Phone Number from the Access Token

This API requires the API consumer to specify a device or phone number as the subject of the API, as follows:

- When using a two-legged access token, the subject is identified from the optional device object or phoneNumber field, which must be provided.
- In contrast, when a three-legged access token is used, this optional identifier must not be provided, as the subject is uniquely identified from the access token.

This approach simplifies API usage for consumers using a three-legged access token, relying on the information associated with the access token and identified during the authentication process.


## Error Handling

- If the subject cannot be identified from the access token and no optional `device` object or `phoneNumber` field is provided in the request, the server will return a `422 MISSING_IDENTIFIER` error.
- If the subject can be identified from the access token and an optional `device` object or `phoneNumber` field is also included in the request, the server will return a `422 UNNECESSARY_IDENTIFIER` error, even if the same device or phone number is identified by both methods, as the server is unable to make this comparison.

