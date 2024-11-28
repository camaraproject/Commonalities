# API design guidelines

This document captures guidelines for the API design in CAMARA project. These guidelines are applicable to every API to be worked out under the CAMARA initiative.

## Table of Contents

- [API design guidelines](#api-design-guidelines)
  - [Table of Contents](#table-of-contents)
  - [Common Vocabulary and Acronyms](#common-vocabulary-and-acronyms)
  - [1. Introduction](#1-introduction)
  - [2. APIfication Principles](#2-apification-principles)
    - [2.1 Domain Driven Design](#21-domain-driven-design)
    - [2.2 API First](#22-api-first)
    - [2.3 Interface standardization. Standardization fora.](#23-interface-standardization-standardization-fora)
    - [2.4 Information Representation Standard](#24-information-representation-standard)
    - [2.5 Reduce telco-specific terminology in API definitions](#25-reduce-telco-specific-terminology-in-api-definitions)
  - [3. API Definition](#3-api-definition)
    - [3.1 API REST](#31-api-rest)
      - [POST or GET for transferring sensitive or complex data](#post-or-get-for-transferring-sensitive-or-complex-data)
    - [3.2 HTTP Response Codes](#32-http-response-codes)
    - [3.3 Query Parameters Use](#33-query-parameters-use)
    - [3.4 Path Parameters Use](#34-path-parameters-use)
    - [3.5 HTTP Headers Definition](#35-http-headers-definition)
    - [3.6 MIME Types](#36-mime-types)
      - [3.6.1 Content-Type character set](#361-content-type-character-set)
  - [4. API Resource Definition](#4-api-resource-definition)
    - [4.1 URL Definition](#41-url-definition)
    - [4.2 Input/Output Resource Definition](#42-inputoutput-resource-definition)
  - [5. Versioning](#5-versioning)
    - [5.1 API version (OAS info object)](#51-api-version-oas-info-object)
    - [5.2 API version in URL (OAS servers object)](#52-api-version-in-url-oas-servers-object)
    - [5.3 API versions throughout the release process](#53-api-versions-throughout-the-release-process)
    - [5.4 Backward and forward compatibility](#54-backward-and-forward-compatibility)
  - [6. Error Responses](#6-error-responses)
    - [6.1 Standardized use of CAMARA error responses](#61-standardized-use-of-camara-error-responses)
    - [6.2 Error Responses - Device Object](#62-error-responses---device-object)
      - [Templates](#templates)
        - [Response template](#response-template)
        - [Examples template](#examples-template)
  - [7. Common Data Types](#7-common-data-types)
  - [8. Pagination, Sorting and Filtering](#8-pagination-sorting-and-filtering)
    - [8.1 Pagination](#81-pagination)
    - [8.2 Sorting](#82-sorting)
    - [8.3 Filtering](#83-filtering)
  - [9. Architecture Headers](#9-architecture-headers)
  - [10. Security](#10-security)
    - [10.1 API REST Security](#101-api-rest-security)
    - [10.2 Security Implementation](#102-security-implementation)
  - [11. Definition in OpenAPI](#11-definition-in-openapi)
    - [11.1 General Information](#111-general-information)
      - [Info object](#info-object)
      - [Servers object](#servers-object)
    - [11.2 Published Routes](#112-published-routes)
    - [11.3 Request Parameters](#113-request-parameters)
    - [11.4 Response Structure](#114-response-structure)
    - [11.5 Data Definitions](#115-data-definitions)
      - [11.5.1 Usage of discriminator](#1151-usage-of-discriminator)
        - [Inheritance](#inheritance)
        - [Polymorphism](#polymorphism)
    - [11.6 Security definition](#116-security-definition)
      - [OpenAPI security schemes definition](#openapi-security-schemes-definition)
      - [Expressing Security Requirements](#expressing-security-requirements)
      - [Mandatory template for `info.description` in CAMARA API specs](#mandatory-template-for-infodescription-in-camara-api-specs)
      - [11.6.1 Scope naming](#1161-scope-naming)
        - [APIs which do not deal with explicit subscriptions](#apis-which-do-not-deal-with-explicit-subscriptions)
          - [Examples](#examples)
        - [APIs which deal with explicit subscriptions](#apis-which-deal-with-explicit-subscriptions)
        - [API-level scopes (sometimes referred to as wildcard scopes in CAMARA)](#api-level-scopes-sometimes-referred-to-as-wildcard-scopes-in-camara)
    - [11.7 Resource access restriction](#117-resource-access-restriction)
  - [12. Subscription, Notification \& Event](#12-subscription-notification--event)
    - [12.1 Subscription](#121-subscription)
      - [Instance-based (implicit) subscription](#instance-based-implicit-subscription)
        - [Instance-based (implicit) subscription example](#instance-based-implicit-subscription-example)
      - [Resource-based (explicit) subscription](#resource-based-explicit-subscription)
        - [Operations](#operations)
        - [Rules for subscriptions data minimization](#rules-for-subscriptions-data-minimization)
        - [Subscriptions data model](#subscriptions-data-model)
        - [Error definition for resource-based (explicit) subscription](#error-definition-for-resource-based-explicit-subscription)
        - [Termination for resource-based (explicit) subscription](#termination-for-resource-based-explicit-subscription)
        - [Resource-based (explicit) example](#resource-based-explicit-example)
    - [12.2 Event notification](#122-event-notification)
      - [Event notification definition](#event-notification-definition)
      - [subscription-ends event](#subscription-ends-event)
      - [Error definition for event notification](#error-definition-for-event-notification)
      - [Correlation Management](#correlation-management)
      - [Security Considerations](#security-considerations)
      - [Abuse Protection](#abuse-protection)
      - [Notification examples](#notification-examples)
  - [Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier](#appendix-a-normative-infodescription-template-for-when-user-identification-can-be-from-either-an-access-token-or-explicit-identifier)


## Common Vocabulary and Acronyms

| **Term**       | Description                                                                                                                                                                                                                                                                                                                                         |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| **API**        | Application Programming Interface. It is a rule & specification group (code) that applications follow to communicate between them, used as interface among programs developed with different technologies.                                                                                                                                          |
|**api-name**    | `api-name` is a kebab-case string used to create unique names or values of objects and parameters related to given API. For example, for Device Location Verification API, api-name is `location-verification`.|
| **Body**       | HTTP Message body (If exists) is used to carry the entity data associated with the request or response.                                                                                                    |
| **Camel Case** | It is a kind of define the fields’ compound name or phrases without whitespaces among words. It uses a capital letter at the beginning of each word. There are two different uses:<li>Upper Camel Case: When the first letter of each word is capital.</li><li>Lower Camel Case: Same to that Upper one, but with the first word in lowercase.</li> |
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


## 1. Introduction
The purpose of this document is to provide a technical description of aspects pertinent to the proper design of Application Programming Interfaces (APIs), hereinafter referred to as APIs. 
It serves as a recommended reference for API development in telecommunication operators and related projects.

Based on principles of standardization, normalization and good practices, this document explains the guidelines for the design and definition of an API, elaborating the following points:

- How to make a proper API definition?
- What are the main aspects to cover?
- What are the best practices for designing an API and managing it properly?
  
This document is addressed to all the roles and people that may participate in a Programmable Interface (API) design and assumes that they have basic knowledge of what an API is. 


## 2. APIfication Principles

APIs are critical components of digitization that enable us to expose the functions and capabilities existing in our systems and network in a secure and standardized way (service channels, between systems/platforms and third parties/partners) without needing to redesign or re-create them (enhancing reuse) with the consequent saving of time and investment.

The APIfication program is based on the following key principles: i) Domain Driven Design; ii) API First; and iii) Standardization.

### 2.1 Domain Driven Design
The main idea of the Domain Driven Design (DDD) approach is "<em>to develop software for a complex domain, we need to build a ubiquitous language that embeds the domain's terminology in the software systems we build</em>" (Fowler, 2020).

This approach to software development focuses efforts on defining for each defined domain.
This model includes a broad understanding of the processes and rules for that domain.

The DDD approach is particularly suitable for complex domains, where a lot of messy logic needs to be organized.
The DDD principles are based on:

- Placing the organization's business models and rules in the core of the application.
- Get a better perspective at the level of collaboration between domain experts and developers, to conceive software with very clear goals.

As an initial reference to define the different domains and subdomains, we rely on the TM Forum SID model, illustrated in the figure below.

![TMF SID](./images/guidelines-fig-1.png)

This set of domains and subdomains is not fixed or static and can evolve over time, depending on the needs for the development and conceptualization of new business or technological elements.

The following figure shows a representation of the concepts handled by the Domain Driven Design approach. The entities located at the bottom are those necessary to analyse the domain, while those at the top of the graph are related to the more technical part of software architecture. Therefore, Domain Driven Design is an "<em>approach to the design of software solutions that ranges from the most holistic definition to the implementation of the objects in the code</em>". 
![Domain Driven Design approach ](./images/guidelines-fig-2.png)

### 2.2 API First

API First strategy consists of considering APIs and everything related to them (definition, versioning, development, promotion...) as a product.

This design strategy considers the API as the main interface of the application.
It initially begins with its design and documentation, to later develop the backend part, instead of setting up the entire backend first and then adapting the API to everything built.

In this way, the technological infrastructure depends directly on the design of the services instead of being a response to their implementation.

Among the main benefits of an "API-First" development strategy, we can highlight:

- Development teams can work in parallel. 
- Reduces the cost of application development.
- Increases speed to market.
- Ensures good developer experiences.


### 2.3 Interface standardization. Standardization fora.
Ensuring the reusability of integrations between elements and systems requires industry-wide agreement.
This involves defining a series of interfaces (by network element providers,
system providers, customer service providers, ...) to guarantee specific functionality and responses.

There are different organizations, standardization forums and collaboration projects that define specific interfaces for certain domains, which are then implemented by different industry agents: integrators, software manufacturers, etc... Some of these organizations, specialized in network domains, include 3GPP, ETSI, IETF and Broadband Forum, among others.

At the systems level, the reference organization is the Telemanagement Forum (TM Forum).
TM Forum is a global association
that drives collaboration and collective problem-solving
to maximize the business success of telecommunications companies and their provider ecosystem.
Its purpose is to help this ecosystem to transform and prosper in the digital age.

**TM Forum Frameworx** is a set of best practices and standards for evaluating and optimizing process performance, using a service approach to operations. The tools available in Frameworx help to improve end-to-end service management in complex, multi-stakeholder environments. It has been widely adopted by the telecommunication industry, providing a common language of processes, functional capabilities, and information. 

The TM Forum Frameworx is composed of:

- Business Process Framework, also known to as enhanced Telecom Operations Map (`eTOM`): it is a reference framework for defining the business processes of telecommunications operators.
- Application Framework Fundamentals (`TAM`): it groups functionalities into recognizable applications to automate processes that will help us to plan and optimize an application portfolio.
- The Information Framework, also known to as Shared Information/Data Model (`SID`): it unifies a reference data model that provides a single set of terms for business objects in telecommunications. The goal is to enable people from different departments, companies, or geographic locations to use the same terms to describe the same real-world objects, practices, and relationships.

Over the last years, TMForum is performing a complete transformation of its architecture, moving from Frameworx, whose paradigm is based on applications, to the Open Digital Architecture (`ODA`), based on modular components.

TM Forum further defines a set of reference APIs (TMF Open APIs) between the different architecture components.


### 2.4 Information Representation Standard

As a messaging standard,
[JSON](https://datatracker.ietf.org/doc/html/rfc8259) is proposed as the default in Camara
because it is a lightweight data exchange format widely adopted by current web technologies.
However, other data types can be used depending on functional and technical requirements.

### 2.5 Reduce telco-specific terminology in API definitions
CAMARA aims to produce 'intent-based' APIs, which have two key benefits:
- for the developer: it does not assume familiarity with the network that will fulfil the API.
- for the operator: it avoids tight-coupling, meaning the API can be fulfilled by various networks (mobile, fixed, satellite etc.) and network versions (4/5/6G etc.)

To realise these benefits, it is important to reduce the use of telco-specific terminology/acronyms in developer-facing APIs. 

CAMARA API designers should:
- Consider and account for how the API can be fulfilled on a range of network types
- Avoid terms/types specific to a given telco domain. For example, the acronym 'UE': in 3GPP terminology this refers to 'User Equipment', but 'UE' means 'User Experience' for most Web developers: 'Terminal' would be a more appropriate, and unambiguous, term. If the usage of a telco-specific term is unavoidable, either:
 - allow a choice, so the developer can use other types. E.g. `MSISDN` should not be the _only_ way to identify an end user.
 - use abstractions, which can evolve: e.g., an `endUserIdentifier` enumeration can support multiple identifiers.
 - explain the telco-specific term in the documentation, and any constraints it brings.


## 3. API Definition

API definition aims to capture 100% of the functional, syntax and semantic documentation of a contract. It is a critical element for the business strategy and will tag the product offered success.

Outstanding aspects in the API definition are:

- API must be defined from a product view focused on API consumers. It means it should be prepared for a top-down definition of all APIs.
- Product should be focused on usability.
- API contract must be correctly documented, and it will be published in a shared catalog.
- API exposure definition will be based on “resources could be used by different services and product consumers”. That means, API definition should be a 360-degree product view.
  
API definition must consider the next assertions:

- API resources definition contains the URI and enterprise resources.
- REST specification compliance aims to make the API fully interoperable.
- API resource security.
- Product consumption experience.
- API measurement over how many, who and when it is used.
- API must be versioned, and a version must figure in all operation URLs. It allows a better last develops management and surveillance, it avoids out of date URLs request, and it makes available coexistence of more than one version productive in the same environment.
- Expose the required fields by the API consumers only. Sometimes, all the response body is not necessary for consumers. Allows more security, less network traffic and agile API usability.
- One of the API Quality requirements will be the evolution and management scalability, lined with versioning and backward compatibility considerations detailed in this document.
- At API definition time is necessary to include audit parameters to allow making surveillance and next maintenance.
- English use must be applied in the OpenAPI definition.

### 3.1 API REST

Representational state transfer (REST) is a software architectural style created to guide the design and development of the architecture for the World Wide Web. REST defines a set of constraints on how the architecture of an Internet-scale distributed hypermedia system, such as the Web, should behave. 

The formal REST constraints are as follows:

- **Client–server architecture**. The client-server design pattern enforces the principle of separating concerns: separating the user interface concerns from the data storage concerns. Portability of the user interface is thus improved. In the case of the Web, a plethora of web browsers have been developed for most platforms without the need for knowledge of any server implementations. Separation also simplifies the server components, improving scalability, but more importantly it allows components to evolve independently (anarchic scalability), which is necessary in an Internet-scale environment that involves multiple organisational domains.
- **Statelessness**. In computing, a stateless protocol is a communications protocol in which no session information is retained by the receiver, usually a server. Relevant session data is sent to the receiver by the client in such a way that every packet of information transferred can be understood in isolation, without context information from previous packets in the session. This property of stateless protocols makes them ideal in high-volume applications, increasing performance by removing server load caused by retention of session information.
- **Cacheability**: As on the World Wide Web, clients and intermediaries can cache responses. Responses must, implicitly or explicitly, define themselves as either cacheable or non-cacheable to prevent clients from providing stale or inappropriate data in response to further requests. Well-managed caching partially or eliminates some client–server interactions, further improving scalability and performance.
- **Layered system**: A client cannot ordinarily tell whether it is connected directly to the end server or to an intermediary along the way. If a proxy or load balancer is placed between the client and server, it won't affect their communications, and there won't be a need to update the client or server code.
- **Uniform interface**: The uniform interface constraint is fundamental to the design of any RESTful system. It simplifies and decouples the architecture, which enables each part to evolve independently. The four constraints for this uniform interface are:
  - <u>Resource identification in requests</u>. Individual resources are identified in requests, for example, using URIs in RESTful Web services. The resources themselves are conceptually separate from the representations that are returned to the client. For example, the server could send data from its database as HTML, XML or as JSON—none of which are the server's internal representation.
  - <u>Resource manipulation through representations</u>.  When a client holds a representation of a resource, including any metadata attached, it has enough information to modify or delete the resource's state.
  - <u>Self-descriptive messages</u>. Each message includes enough information to describe how to process the message. For example, a media type can specify which parser to invoke.
  - <u>Hypermedia as the engine of application state (HATEOAS)</u>. Having accessed an initial URI for the REST application (analogous to a human Web user accessing the home page of a website). A REST client should then be able to use server-provided links dynamically to discover all the available resources it needs. As access proceeds, the server responds with text that includes hyperlinks to other resources that are currently available. There is no need for the client to be hard-coded with information regarding the structure or dynamics of the application.

<font size="3"><span style="color: blue"> HTTP verbs </span></font>

HTTP standard should be followed to the verb usability, resulting in an API definition oriented to the RESTful design.
Any HTTP correct verb usability is allowed.

Principal methods (Verbs) available to use are next ones:

| **HTTP Verb** | **CRUD operation** | **Description**                                                                                                                                                                                                                            |
|---------------|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| GET           | Read               | Retrieve the actual resource status                                                                                                                                                                                                        |
| POST          | Create             | Creates a new resource in the collection. Returns the resource URL when the creation ends.                                                                                                                                                 |
| PUT           | Update             | Replaces a specific resource. Returns the resource URL when the replace ends.                                                                                                                                                              |
| DELETE        | Delete             | Delete a specific resource.                                                                                                                                                                                                                |
| PATCH         | Update             | Updates a specific resource, applying all changes at the same time. If a resource does not exist, it will be created. Returns the resource URL when the update ends. If any error occurs during the update, all of them will be cancelled. |
| OPTIONS       | Read               | Returns a 200 OK with an allowed methods list in the specific resource destined to the header allowed joined to an HTML document about the resource + an API Doc link.                                                                     |

In this document will be defined the principal verbs to use in the API definition.

- `POST`: it is used to send date to the server.
- `GET`: it allows performing all the read and retrieve operations. GET operation should be based on data retrieving, that’s why the retrieve operation must be realized directly from the URI including some identifiers and query params.
- `PUT`: it allows updating entity data, deleting one or more fields from this entity body if there are not informed.  New information to update must be informed by JSON language sent in the body request. If operation requires extra information, Query params could be used. PUT case, if a registry does not exist in server data storage, it will be created, that means this operation could be used to create new resources.
- `DELETE`: it allows deleting full entities from server. From a consumer perspective, it is not a reversible action. (Rollback action is not available).
- `PATCH`: it allows updating partial fields of a resource.

<br>

#### POST or GET for transferring sensitive or complex data

Using the GET operation to pass sensitive data potentially embeds this information in the URL
if contained in query or path parameters.
For example, this information can remain in browser history, could be visible to anyone who can read the URL,
or could be logged by elements along the route such as gateways and load balancers.
This increases the risk that the sensitive data may be acquired by unauthorised third parties.
Using HTTPS does not solve this vulnerability,
as the TLS termination points are not necessarily the same as the API endpoints themselves.

The classification of data tagged as sensitive should be assessed for each API project, but might include the following examples:
-  phone number (MSISDN) must be cautiously handled as it is not solely about the number itself, but also knowing something about what transactions are being processed for that customer
-  localisation information (such as latitude & longitude) associated with a device identifier as it allows the device, and hence customer, location to be known
-  physical device identifiers, such as IP addresses, MAC addresses or IMEI

In such cases, it is recommended to use one of the following methods to transfer the sensitive data:
- When using `GET`, transfer the data using headers, which are not routinely logged or cached
- Use `POST` instead of `GET`, with the sensitive data being embedded in the request body which, again, is not routinely logged or cached 

When the `POST` method is used, the resource in the path *must* be a verb (e.g. `retrieve-location` and not `location`) to differentiate from an actual resource creation.

It is also fine to use POST instead of GET:
- to bypass technical limitations, such as URL character limits (if longer than 4k characters) or passing complex objects in the request
- for operations where the response should not be kept cached, such as anti-fraud verifications or data that can change asynchronously (such as status information)

### 3.2 HTTP Response Codes

HTTP status response codes indicate if a request has been completed successfully. Response codes are grouped by five classes.

1.	Inform responses (1XX)
2.	Success responses (2XX)
3.	Redirections (3XX)
4.	Client Errors (4XX)
5.	Server Errors (5XX)

Status codes are defined in the [RFC 2616](https://tools.ietf.org/html/rfc2616#section-10) 10th section. You can get the updated specifications from [RFC 9110 Status Codes](https://datatracker.ietf.org/doc/html/rfc9110#section-15).

Common errors are captured in the table below. 

| **Error code** | **Description**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| 200            | 200 (OK) status code indicates that the request result successfully<br>`GET`-> 200 HTTP Code by default.<br>`POST`/`PUT`/`PATCH` -> Resource update actions, data is returned in a body from server side.<br>`DELETE` -> Resource delete action, data is returned in a body from server side.</br>                                                                                                                                                                                                                                                                               |
| 201            | 201 (Created) HTTP code indicates that the request has created one or more resource successfully.<br>`POST`/`PUT` -> When a resource is created successfully.                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 202            | 202 (Accepted) code indicated that the request has been accepted to be processed, but it has not ended.<br>Usually, when a `DELETE` is requested but the server cannot make the action immediately. It should apply to async processes.                                                                                                                                                                                                                                                                                                                                          |
| 203            | 203 (Unauthorized information) code indicated that the request has been successfully, but the attached payload was modified from the 200 (OK) response from the origin server using a transformation proxy.<br>It is used when data sent in the request could be modified as a third data subset.                                                                                                                                                                                                                                                                                |
| 204            | 204 (No Content) indicated that the server has ended successfully the request and there is nothing to return in the body response.<br>`POST` -> When used to modify a resource and output is not returned.<br>`PUT`/`PATCH` -> When used to modify a resource and output is not returned.<br>`DELETE` -> Resource delete action and output is not returned.<br> _NOTE: This list of levels MAY be extended with new values. The OpenID Provider (Auth Server) and the APIs used by the Relying Parties (client Applications) MUST be ready to support new values in the future._ |
| 206            | 206 (Partial Content) The server has fulfilled the partial GET request for the resource.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| 400            | 400 (Bad Request) status code indicates that the server cannot or will not process the request due to something perceived as a client error (for example, malformed request syntax, invalid request message structure, or incorrect routing). <br>This code must be documented in all the operations in which it is necessary to receive data in the request.                                                                                                                                                                                                                    |
| 401            | 401 (Unauthorized) status code indicates that the request has not been applied because it lacks valid authentication credentials for the target resource.<br>This code has to be documented in all API operations that require subscription by a client.                                                                                                                                                                                                                                                                                                                         |
| 403            | 403 (Forbidden) status code indicates that the server understood the request, but is refusing to authorize it. A server that wants to make public why the request was prohibited can describe that reason in the response payload (if applicable).<br>This code is usually documented in the operations. It will be returned when the OAuth2 token access does not have the required scope or when the user fails operational security.                                                                                                                                          |
| 404            | 404 (Not Found) status code indicates that the origin server either did not find a current representation for the target resource or is unwilling to reveal that it exists.<br>This code will occur on `GET` operations when the resource is not available, so it is necessary to document this return in such situations.                                                                                                                                                                                                                                                       |
| 405            | 405 (Method Not Allowed) status code indicates that the origin server knows about the method received in the request line, but the target resource does not support it.<br>This code is documented at the API portal level, it should not be documented at the API level.                                                                                                                                                                                                                                                                                                        |
| 406            | 406 (Not Acceptable) status code indicates that the target resource does not have a current representation that would be acceptable to the user, based on the proactive negotiation header fields received in the request, and the server is unwilling to provide a predetermined representation. It must be reported when there is no response by default, and header fields are reported to carry out the content negotiation (Accept, Accept-Charset, Accept-Encoding, Accept-Language).                                                                                      |
| 408            | Status code 408 (Request Timeout) indicates that the server did not receive the complete request message within the expected time.<br>This code is documented at the API portal level, it should not be documented at the API level.                                                                                                                                                                                                                                                                                                                                             |
| 409            | The 409 (Conflict) status code indicates when a request conflicts with the current state of the server.                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 410            | The 410 (Gone) status code indicates that access to the target resource is no longer available at the origin server and that this condition is likely to be permanent.                                                                                                                                                                                                                                                                                                                                                                                                           |
| 415            | The 415 (Unsupported Media Type) status code indicates that the server cannot accept the format of the request body as indicated by the `Content-Type` or `Content-Encoding` request header. The API specification will state what request body format should be used.                                                                                                                                                                                                                                                                                                           |
| 422            | The 422 (Unprocessable Entity) status code means the server understands the content type of the request body, and the syntax of the request body is correct but it was unable to process the contained instructions.                                                                                                                                                                                                                                  |
| 429            | The 429 (Too Many Requests) status code indicates that the server is temporarily unable to accept any more requests from the client due to the high number of requests recently sent. A `Retry-After` response header may indicate how long the client should wait before trying again.                                                                                                                                                                                                                                                                                          |
| 500            | Status code 500 (Internal Server Error) indicates that the server encountered an unexpected condition that prevented it from fulfilling the request.<br>This code must always be documented. It should be used as a general system error.                                                                                                                                                                                                                                                                                                                                        |
| 501            | Status code 501 (Not Implemented) indicates that the requested method is not supported by the server and cannot be handled. The only methods that servers require support (and therefore should not return this code) are `GET` and HEAD.                                                                                                                                                                                                                                                                                                                                        |
| 502            | Status code 502 (Bad Gateway) indicates that the server, while working as a gateway to get a response needed to handle the request, got an invalid response.                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 503            | Status code 503 (Service Unavailable) status code indicates that the server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay.                                                                                                                                                                                                                                                                                                                                                    |
| 504            | Status code 504 (Gateway Timeout) indicates that the server is acting as a gateway and cannot get a response in time.                                                                                                                                                                                                                                                                                                                                                                                                                                                            |

### 3.3 Query Parameters Use

API query parameters can be defined as key-value pairs that appear after the question mark in the URL. Basically, they are URL extensions used to help determine the specific content or action based on the data being delivered. Query parameters are added at the end of the URL, using a "`?`". The question mark is used to separate the path and the query parameters.

<p style="text-align: center;">
  <img src="./images/guidelines-fig-9.png" alt="drawing" width="350"/>
</p>

If you want to add multiple query parameters, an "`&`" is placed between them to form a query string.
You can present a lot of object types with different lengths, such as arrays, strings, and numbers.

### 3.4 Path Parameters Use

A path param is a unique identifier for the resource. For example:

- ```/users/{userId}```

Multiple path params can be entered if there is a logical path of mutually dependent resources.
- ```/users/{userId}/documents/{documentId}```

<font size="3"><span style="color: blue"> Good Practices </span></font>


1. Path params cannot be concatenated. A path param must be preceded by the resource represented. If we did this, the URL would be incomprehensible:
   - ```/users/{userId}/{documentId}```
   - ```/users/13225365/647658```
  <br></br>
2. The attribute must be identifying itself, it is not enough with "`{id}`"
   - ```/users/{id}```
  <br></br>

   Reason is that if this resource is "extended" in the future and includes other identifiers, we would not know which of the entities the "`{id}`" parameter refers to. For example:
   - Incorrect: ```/users/{id}/documents/{documentId}```
   - Correct: ```/users/{userId}/documents/{documentId}```
<br></br>
3. It is recommended that the identifier have a similar morphology on all endpoints. For example, “`xxxxId`”, where xxx is the name of the entity, it references:
   - ```/users/{userId}```
   - ```/accounts/{accountId}```
   - ```/vehicles/{vehicleId}```
   - ```/users/{userId}/vehicles/{vehicleId}```
<br></br>
4. Care must be taken not to create ambiguities in the URIs when defining paths. For example, if the "user" entity can be identified by two unique identifiers, and we will create two URIs. 
   - ```/users/{userId}```
   - ```/users/{nif}```
<br></br>
5. Identifiers must be, as far as possible, of a hash type or similar so that we avoid enumeration or brute force attacks for their deduction.

Upon API invocation, one of the options would be chosen, and we would not be able to distinguish which one was chosen.

### 3.5 HTTP Headers Definition
Request header parameters are a great addition to the design of our API functionality.
The purpose of this document is not to describe all the possibilities offered by the HTTP protocol. 
Instead, it aims 
to take the use of HTTP headers into account during the definition and design of APIs to improve their characteristics.

The main HTTP headers are described below:

- `Accept`: this header can be used to specify certain types of data that are acceptable for the response. `Accept` headers can be used to indicate that the request is specifically limited to a small set of desired types, as in the case of a request for an image.
- `Accept-Encoding`: similar to the `Accept` header, but restricting the content encodings that are acceptable in the response. 
- `Accept-Language`: the consumer defines the list of languages in order of preference. The server answer with the `Content-Language` field in the header with the response language.
- `Authorization`: it allows sending the authorization token for API access, initially OAuth2 and JWT.
- `Content-Type`: it indicates the type of message sent to the recipient or, in the case of the HEAD method, the type of message that would have been sent if the request had been a GET. The MIME type of the response, or the content uploaded via POST/PUT in case it is a request. 
- `Content-Length`: it indicates the message size, in octets, sent to the recipient or, in the case of the HEAD method, the message size that would have been sent if the request had been a GET. The size of the response in octets (8Bits) 
- `Content-Encoding`: it is used as a message type modifier. The type of encoding used in the response is indicated.
- `Host`:  specifies the host and port number of the server to which the request is being sent.

<font size="3"><span style="color: blue"> Optional recommended security headers by OWASP </span></font>

- `HTTP Strict Transport Security`: a web security policy mechanism which helps to protect websites against protocol downgrade attacks and cookie hijacking. It allows web servers to declare that web browsers (or other complying user agents) should only interact with it using secure HTTPS connections, and never via the insecure HTTP protocol.
- `X-Frame-Options`: a response header (also named XFO) which improves the protection of web applications against clickjacking. It instructs the browser whether the content can be displayed within frames.
- `X-Content-Type-Options`: setting this header will prevent the browser from interpreting files as a different MIME type to what is specified in the Content-Type HTTP header (e.g. treating text/plain as text/css).
- `Content-Security-Policy`: it requires careful tuning and precise definition of the policy. If enabled, CSP has a significant impact on the way browsers render pages (e.g. inline JavaScript is disabled by default and must be explicitly allowed in the policy). CSP prevents a wide range of attacks, including cross-site scripting and other cross-site injections.
- `X-Permitted-Cross-Domain-Policies`: a cross-domain policy file is an XML document that grants a web client, such as Adobe Flash Player or Adobe Acrobat (though not necessarily limited to these), permission to handle data across domains. When clients request content hosted on a particular source domain and that content makes requests directed towards a domain other than its own, the remote domain needs to host a cross-domain policy file. This file grants access to the source domain, allowing the client to continue the transaction.
- `Referrer-Policy`: it governs which referrer information (sent in the Referrer header) should be included with requests made.
- `Clear-Site-Data`: it clears browsing data (e.g. cookies, storage, cache) associated with the requesting website. It allows web developers to have more control over the data stored locally by a browser for their origins.
- `Cross-Origin-Embedder-Policy`: it prevents a document from loading any cross-origin resources that don’t explicitly grant the document permission.
- `Cross-Origin-Opener-Policy`: this response header (also referred to as COOP) allows you to ensure a top-level document does not share a browsing context group with cross-origin documents. COOP will process-isolate your document and potential attackers can’t access to your global object if they were opening it in a popup, preventing a set of cross-origin attacks dubbed XS-Leaks.
- `Cross-Origin-Resource-Policy`: this response header (also referred to as CORP) allows to define a policy that lets websites and applications opt in to protection against certain requests from other origins (such as those issued with elements like "`<script>`" and "`<img>`"), to mitigate speculative side-channel attacks, like Spectre, as well as Cross-Site Script Inclusion (XSSI) attacks.
- `Cache-Control`: it holds directives (instructions) for caching in both requests and responses. If a given directive is in a request, it does not mean this directive is in the response.

To avoid cluttering the CAMARA OAS (Swagger) definition files, the above headers must not be included explicitly in the API definition files even when supported, as it can be assumed that developers will already be familiar with their use.

<font size="3"><span style="color: blue"> The following HTTP headers are not allowed:</span></font>

- `Server`. This header offers relevant information on the server side, including a version and in-scope services. It is strongly recommended to disable this header to avoid disclosing such information. 
- `X-Powered-By`. This header describes the technology used to implement the exposed service. This information can be useful to potential attackers and should be avoided.
- `X-Frame-Options`. This header is generally used to prevent clickjacking attacks, but there is a more standard header to do this called "Content-Security-Policy". This header is no longer needed.
- `X-UA-Compatible`. Microsoft introduced this header to provide compatibility with legacy versions of IE (IE8, IE7, ...). APIs are not considered to have a web interface, so this header is not useful.
- `Expires`. Since the `Cache-Control` header can offer an expiration date/time for cached values, this header is no longer needed and should be avoided.
- `Pragma`. The `Cache-Control` header will do the same job as "Pragma" too, it is more standard, so should be avoided.


### 3.6 MIME Types
During the API definition process, API MIME types must be identified, explaining how the data will be sent to the resource and how the resource will return it to the consumption.

Due to interoperability reasons and to comply as closely as possible with REST,
it is recommended using standard mime-types, avoid the creation of new mime-types.

The standard headers that allow managing the data format are:
- `Accept`
- `Content-Type`

As a MIME Types example, we can identify:
- `application/xml`
- `application/json`

#### 3.6.1 Content-Type character set

The character set supported must only be UTF-8. The [JSON Data Interchange Format (RFC 8259)](https://datatracker.ietf.org/doc/html/rfc8259#section-8.1) states the following

```
JSON text exchanged between systems that are not part of a closed
ecosystem MUST be encoded using UTF-8 [RFC3629].

Previous specifications of JSON have not required the use of UTF-8
when transmitting JSON text.  However, the vast majority of JSON-
based software implementations have chosen to use the UTF-8 encoding,
to the extent that it is the only encoding that achieves
interoperability.
```

Implementers may include the UTF-8 character set in the Content-Type header value, for example, "application/json; charset=utf-8". However, the preferred format is to specify only the MIME type, such as "application/json". Regardless, the interpretation of the MIME type as UTF-8 is mandatory, even when only "application/json" is provided.


## 4. API Resource Definition

### 4.1 URL Definition

The figure below shows an example of URL definition.
<p style="text-align: center;">
  <img src="./images/guidelines-fig-10.png" alt="drawing" width="400"/>
</p>
As seen, the full URL consist of:

1. **Protocol**: transport protocol specification. We will always use HTTPS.
2.	**Domain**: machine name or domain. It is defined at the server level.
3.	**Context**: the name of the API. Our system may have several differentiated APIs according to its goals and the relationship of its resources.
4.	**Version**: MAJOR version. Part of semantic versioning.
5.	**Resource**: specific resource that we are accessing. It can be made up of several levels.
6.	**Path param**: part of the resource identifier that precedes it. Indicates that it is the user unequivocally identified by "1244".
7.	**Query Param**: resource filter parameters. They are preceded by "?" and as many as defined with "&" can be concatenated.

<font size="3"><span style="color: blue"> Good practices </span></font>

URIs should be designed according to the following considerations:

- URI with lowercase and hyphens. URIs must be "human-readable" to facilitate identification of the offered resources. Lowercase words and hyphenation (kebab-case) help achieve this best practice. For example: `/customer-segments`
- URIs must contain the exposed resource.
- Verb use is not allowed.
- URIs must contain the "major version" of the API. 
- The resource chain will be defined in the API URI following a hierarchical relationship.
  - `<Resource1>/{<id>}/<Resource2>/{<id>}`
  - A collection must always be followed by a member of the collection.
  - The API response should return, if possible, the hypermedia resource which it refers to. Although it is recommended that the REST API be more pragmatic to return in a single call what is necessary to avoid concatenated calls from clients.
  - Short URIs use is recommended for relevant entities. Failure to define a clear hierarchical model will lead to inconsistencies in publishing interfaces through the API and will make it difficult to consume.   
- Avoiding usage of the package type nomenclature (e.g.,"com.mycompany.api...") in the API URI, because it makes it difficult for the developer or consumer to use the API.
- URIs are defined per entity based on CRUD operations. Generally, we should only have one operation verb per functional entity (`GET`, `PUT`, `POST`, `PATCH`, `DELETE`).
- The URI at the business entity level will always be a plural noun.
- OperationIds are defined in lowerCamelCase: For example: `helloWorld`
- Objects are defined in CamelCase inside the property field. For example: `Greetings`, `ExampleObject`.


<font size="3"><span style="color: blue"> Hierachy </span></font>

Hierarchy could be introduced with the concepts of entity and sub-entity:
- **Entity**: it is understood as enough relevant business objects to be identified as a product. An API defines a single entity.
- **Sub-entity**: it is understood as a business object that by itself has no business relevance. It is an object hierarchically related to an entity.

To make the hierarchy, the following aspects must be applied:
- Two levels of hierarchy should not exceed and should not be more than eight resources (6–8).
- A resource has multiple operations identified by HTTP Verbs.
- Resources defined through URIs establish a hierarchical relationship with each other:
  - `/<entity>`<br>
   `/<entity>/{<entityId>}`<br>
   `/<entity>/{<entityId>}/<subEntity>`<br>
   `/<entity>/{<entityId>}/<subEntity>/{<subEntityId>}`


### 4.2 Input/Output Resource Definition

At this point, some considerations are outlined about the business input and output data of the API resources. This data can be informed by different means: QueryString, Header, Body...

These considerations are below:
- API input and output business data will follow the camelCase notation.
- The field names in JSON and XML will follow the same URIs standard.
  - Business data must be human-readable.
  - commercial data name must be a noun. That means it corresponds to entity information.

- Business data sent as part of the HTTP protocol will be exempt from these rules. In these cases, compliance with the standard protocol will apply. 
- Sensitive data (considered this way for security) must go in the body if it is a `POST` request and in the header if it is a `GET`, encrypted by default by the HTTPs protocol.
- Description of the input and output data must have:
  - Functional description
  - Data Type
  - Value range supported



## 5. Versioning

Versioning is a practice by which, when a change occurs in the API, a new version of that API is created.

API versions use a numbering scheme in the format: `x.y.z`

* x, y and z are numbers corresponding to MAJOR, MINOR and PATCH versions.
* MAJOR, MINOR and PATCH refer to the types of changes made to an API through its evolution.
* Depending on the change type, the corresponding number is incremented.
* This is defined in the [Semantic Versioning 2.0.0 (semver.org)](https://semver.org/) standard.

### 5.1 API version (OAS info object)

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


It is recommended to avoid breaking backward compatibility unless strictly necessary: new versions should be backwards compatible with previous versions. More information on how to avoid breaking changes can be found below.

### 5.2 API version in URL (OAS servers object)

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

This allows for both test and commercial usage of initial API versions as they are evolving rapidly, e.g. `/qod/v0.10alpha1`, `/qod/v0.10rc1`, or `/qod/v0.10`. However, it should be acknowledged that any initial API version may change.

### 5.3 API versions throughout the release process

In preparation for its public release, an API will go through various intermediate versions indicated by version extensions: alpha and release-candidate.

Overall, an API can have any of the following versions:

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

Precedence examples:

* 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1 < 3.0.0.
* 0.1.0 < 0.2.0-alpha.1 < 0.2.0-alpha.2 < 0.2.0-rc.1 < 0.2.0-rc.2 < 0.2.0 (initial public API version)
* 1.0.0 < 1.1.0-alpha.1 < 1.1.0-alpha.2 < 1.1.0-rc.1 < 1.1.0-rc.2 < 1.1.0 (stable public API version)

For more information, please see [API versioning](https://lf-camaraproject.atlassian.net/wiki/x/3yLe) in the Release Management project wiki.

### 5.4 Backward and forward compatibility

Avoid breaking backward compatibility, unless strictly necessary, means that new versions should be compatible with previous versions.

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
- Adding new mandatory input parameters. For example: now, to register a resource, a new required field must be sent in the body of the request.
- Modifying or removing an endpoint (breaks existing queries)
- Changing input parameters from optional to mandatory. For example: when creating a Person resource, the age field, which was previously optional, is now mandatory.
- Modifying or removing a mandatory parameter in existing operations (resource verbs). For example, when consulting a resource, a certain field is no longer returned. Another example: a field that was previously a string is now numeric.
- Modifying or adding new responses to existing operations. For example: creating a resource can return a 412 response code.

Compatibility management:

To ensure this compatibility, the following guidelines must be applied.

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


## 6. Error Responses

To guarantee interoperability,
one of the most important points is
to carry out error management aimed at strictly complying with the error codes defined in the HTTP protocol.

An error representation must not be different from the representation of any resource. A main error message is defined with JSON structure with the following fields:
- A field "`status`", which can be identified in the response as a standard code from a list of Hypertext Transfer Protocol (HTTP) response status codes.
- A unique error "`code`", which can be identified and traced for more details. It must be human-readable; therefore, it must not be a numeric code. In turn, to achieve a better location of the error, you can reference the value or field causing it, and include it in the message.
- A detailed description in "`message`" - in English language in API specification, it can be changed to other languages in implementation if needed.

All these aforementioned fields are mandatory in Error Responses.
`status` and `code` fields have normative nature, so as their use has to be standardized (see [Section 6.1](#61-standardized-use-of-camara-error-responses)). On the other hand, `message` is informative and within this document an example is shown.

Fields `status` and `code` values are normative (i.e. they have a set of allowed values), as defined in [CAMARA_common.yaml](../artifacts/CAMARA_common.yaml).

A JSON error structure is proposed below: 

```json
{
   "status": 400,
   "code": "INVALID_ARGUMENT",
   "message": "A human readable description of what the event represent"
}
```

In error handling, different cases must be considered, even at the functional level that it is possible to modify the error message returned to the API consumer. For this error handling, there are two possible alternatives listed below:
- Error handling done with custom policies in the API admin tool.
- Error management performed in a service queried by API.
  
The essential requirements to consider would be:
- Error handling should be centralized in a single place.
- Customization of the generated error based on the error content returned by the final core service should be contemplated.
- Latency should be minimized in its management.

> _NOTE: When standardized AuthN/AuthZ flows are used, please refer to [10.2 Security Implementation](#102-security-implementation) and [11.6 Security Definition](#116-security-definition), the format and content of Error Response for those procedures SHALL follow the guidelines of those standards.

### 6.1 Standardized use of CAMARA error responses

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
|       403        | `INVALID_TOKEN_CONTEXT` | `{{field}}` is not consistent with access token.                    | Reflect some inconsistency between information in some field of the API and the related OAuth2 Token                            |
|       409        |        `ABORTED`        | Concurrency conflict.                                               | Concurrency of processes of the same nature/scope                                                                               |
|       409        |    `ALREADY_EXISTS`     | The resource that a client tried to create already exists.          | Trying to create an existing resource                                                                                           |
|       409        |       `CONFLICT`        | A specified resource duplicate entry found.                         | Duplication of an existing resource                                                                                             |
|       409        |   `{{SPECIFIC_CODE}}`   | `{{SPECIFIC_CODE_MESSAGE}}`                                         | Specific conflict situation that is relevant in the context of the API                                                          |

<font size="3"><span style="color: blue"> Service Exceptions </span></font>

| **Error status** |        **Error code**         | **Message example**                                                        | **Scope/description**                                                                                                                                                        |
|:----------------:|:-----------------------------:|----------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|       401        |       `UNAUTHENTICATED`       | Request not authenticated due to missing, invalid, or expired credentials. | Request cannot be authenticated                                                                                                                                              |
|       401        |   `AUTHENTICATION_REQUIRED`   | New authentication is required.                                            | New authentication is needed, authentication is no longer valid                                                                                                              |
|       403        |      `{{SPECIFIC_CODE}}`      | `{{SPECIFIC_CODE_MESSAGE}}`                                                | Indicate a Business Logic condition that forbids a process not attached to a specific field in the context of the API (e.g QoD session cannot be created for a set of users) |
|       404        |          `NOT_FOUND`          | The specified resource is not found.                                       | Resource is not found                                                                                                                                                        |
|       404        |      `DEVICE_NOT_FOUND`       | Device identifier not found.                                               | Device identifier not found                                                                                                                                                  |
|       404        |      `{{SPECIFIC_CODE}}`      | `{{SPECIFIC_CODE_MESSAGE}}`                                                | Specific situation to highlight the resource/concept not found (e.g. use in device)                                                                                          |
|       422        | `DEVICE_IDENTIFIERS_MISMATCH` | Provided device identifiers are not consistent.                            | Inconsistency between device identifiers not pointing to the same device                                                                                                     |
|       422        |    `DEVICE_NOT_APPLICABLE`    | The service is not available for the provided device.                      | Service is not available for the provided device                                                                                                                             |
|       422        |    `UNIDENTIFIABLE_DEVICE`    | The device cannot be identified.                                          | The device identifier is not included in the request and the device information cannot be derived from the 3-legged access token                                              |
|       422        |      `{{SPECIFIC_CODE}}`      | `{{SPECIFIC_CODE_MESSAGE}}`                                                | Any semantic condition associated to business logic, specifically related to a field or data structure                                                                       |
|       429        |       `QUOTA_EXCEEDED`        | Either out of resource quota or reaching rate limiting.                    | Request is rejected due to exceeding a business quota limit                                                                                                                  |
|       429        |      `TOO_MANY_REQUESTS`      | Either out of resource quota or reaching rate limiting.                    | API Server request limit is overpassed                                                                                                                                       |

<font size="3"><span style="color: blue"> Server Exceptions </span></font>

| **Error status** |      **Error code**      | **Message example**                                                                                           | **Scope/description**                                                                                                                    |
|:----------------:|:------------------------:|---------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
|       405        |   `METHOD_NOT_ALLOWED`   | The requested method is not allowed/supported on the target resource.                                         | Invalid HTTP verb used with a given endpoint                                                                                             |
|       406        |     `NOT_ACCEPTABLE`     | The server cannot produce a response matching the content requested by the client through `Accept-*` headers. | API Server does not accept the media type (`Accept-*` header) indicated by API client                                                    |
|       410        |          `GONE`          | Access to the target resource is no longer available.                                                         | Use in notifications flow to allow API Consumer to indicate that its callback is no longer available                                     |
|       412        |  `FAILED_PRECONDITION`   | Request cannot be executed in the current system state.                                                       | Indication by the API Server that the request cannot be processed in current system state                                                |
|       415        | `UNSUPPORTED_MEDIA_TYPE` | The server refuses to accept the request because the payload format is in an unsupported format.              | Payload format of the request is in an unsupported format by the Server. Should not happen                                               |
|       500        |        `INTERNAL`        | Unknown server error. Typically a server bug.                                                                 | Problem in Server side. Regular Server Exception                                                                                         |
|       501        |    `NOT_IMPLEMENTED`     | This functionality is not implemented yet.                                                                    | Service not implemented. The use of this code should be avoided as far as possible to get the objective to reach aligned implementations |
|       502        |      `BAD_GATEWAY`       | An upstream internal service cannot be reached.                                                               | Internal routing problem in the Server side that blocks to manage the service properly                                                   |
|       503        |      `UNAVAILABLE`       | Service Unavailable.                                                                                          | Service is not available. Temporary situation usually related to maintenance process in the server side                                  |
|       504        |        `TIMEOUT`         | Request timeout exceeded.                                                                                     | API Server Timeout                                                                                                                       |

> _NOTE 1: When no login has been performed or no authentication has been assigned, a non-descriptive generic error will always be returned in all cases, a `UNAUTHENTICATED` 401 “Request not authenticated due to missing, invalid, or expired credentials.” is returned, whatever the reason._

> _NOTE 2: A {{SPECIFIC_CODE}}, unless it may have traversal scope (i.e. re-usable among different APIs), SHALL follow this scheme for a specific API: {{API_NAME}}.{{SPECIFIC_CODE}}_

### 6.2 Error Responses - Device Object

This section is focused in the guidelines about error responses around the concept of `device` object.

The Following table compiles the guidelines to be adopted:

| **Case #** | **Description**                                                            | **Error status** |         **Error code**         | **Message example**                                      |
|:----------:|:---------------------------------------------------------------------------|:----------------:|:------------------------------:|:---------------------------------------------------------|
|     0      | The request body does not comply with the schema                           |       400        |        INVALID_ARGUMENT        | Request body does not comply with the schema.            |
|     1      | None of the provided device identifiers is supported by the implementation |       422        |     UNSUPPORTED_IDENTIFIER     | The identifier provided is not supported.                                 |
|     2      | Some identifier cannot be matched to a device                              |       404        |        DEVICE_NOT_FOUND        | Device identifier not found.                             |  
|     3      | Device identifiers mismatch                                                |       422        |  DEVICE_IDENTIFIERS_MISMATCH   | Provided device identifiers are not consistent.          |
|     4      | An explicit identifier is provided when a device or phone number has already been identified from the access token |       422        | UNNECESSARY_IDENTIFIER  | The device is already identified by the access token. |
|     5      | Service not applicable to the device                                       |       422        |     DEVICE_NOT_APPLICABLE      | The service is not available for the provided device.    |
|     6      | An identifier is not included in the request and the device or phone number identification cannot be derived from the 3-legged access token |       422        |     MISSING_IDENTIFIER      | The device cannot be identified. |



#### Templates

##### Response template

A response will group all examples for same operation and status code
Schema is common for all errors

```yaml
description: |
  The examples section includes the list of subcases for this status error code to be implemented. In each example `status` and `code` are normative for the specific error case. `message` may be adjusted or localized by the implementation.
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


## 7. Common Data Types

The aim of this clause is to detail standard data types that will be used over time in all definitions, as long as they satisfy the information that must be covered.

It should be noted
that this point is open to continuous evolution over time through the addition of possible new data structures.
To allow for proper management of this ever-evolving list, an external repository has been defined to that end.
This repository is referenced below. 

[Link to Common Data Types documentation repository](../artifacts/CAMARA_common.yaml)


## 8. Pagination, Sorting and Filtering

Exposing a resource collection through a single URI can cause applications to fetch large amounts of data when only a subset of the information is required. For example, suppose a client application needs to find all orders with a cost greater than a specific value. You could retrieve all orders from the /orders URI and then filter these orders on the client side. This process is highly inefficient. It wastes network bandwidth and processing power on the server hosting the web API.
To alleviate the above-mentioned issues and concerns, Pagination, Sorting and Filtering may optionally be supported by the API provider. The Following subsections apply when such functionality is supported.

### 8.1 Pagination
Services can answer with a resource or article collections. Sometimes these collections may be a partial set due to performance or security reasons. Elements must be identified and arranged consistently on all pages. Paging can be enabled by default on the server side to mitigate denial of service or similar.

Services must accept and use these query parameters when paging is supported:
- `perPage`: number of resources requested to be provided in the response 

- `page`: requested page number to indicate the start of the resources to be provided in the response (considering perPage page size)
- `seek`: index of last result read, to create the next/previous number of results. This query parameter is used for pagination in systems with more than 1000 records. `seek` parameter offers finer control than `page` and could be used one or another as an alternative. If both are used in combination (not recommended) `seek` would mark the index starting from the page number specified by `page` and `perPage` [index = (page * perPage) + seek].


Services must accept and use these headers when paging is supported:
- `Content-Last-Key`: it allows specifying the key of the last resort provided in the response
- `X-Total-Count`: it allows indicating the total number of elements in the collection

If the server cannot meet any of the required parameters, it should return an error message.

The HTTP codes that the server will use as a response are:
- `200`: the response includes the complete list of resources
- `206`: the response does not include the complete list of resources
- `400`: request outside the range of the resource list
 
Petitions examples:
- `page=0 perPage=20`, which returns the first 20 resources
- `page=10 perPage=20`, which returns 20 resources from the 10th page (in terms of absolute index, 10 pages and 20 elements per page, means it will start on the 200th position as 10x20=200)



### 8.2 Sorting

Sorting the result of a query on a resource collection requires two main parameters:
Note: Services must accept and use these parameters when sorting is supported.  If a parameter is not supported, the service should return an error message.
- `orderBy`: it contains the names of the attributes on which the sort is performed, with comma separated if there is more than one criteria.
- `order`: by default, sorting is done in descending order. 

If you may want to specify which sort criteria, you need to use "asc" or "desc" as query value.

For example, The list of orders is retrieved, sorted by rating, reviews and name with descending criteria.
```http
https://api.mycompany.com/v1/orders?orderBy=rating,reviews,name&order=desc
```

### 8.3 Filtering


Filtering consists of restricting the number of resources queried by specifying some attributes and their expected values. When filtering is supported, it is possible to filter a collection of multiple attributes at the same time and allow multiple values for a filtered attribute.

Next, it is specified how it should be used according to the filtering based on the type of data being searched for: a number or a date and the type of operation.

Note: Services may not support all attributes for filtering.  In case a query includes an attribute for which filtering is not supported, it may be ignored by the service.

#### Security Considerations
As filtering may reveal sensitive information, privacy and security constraints have to be considered when defining query parameters, e.g. it should not be possible to filter using personal information (such as name, phone number or IP address).


#### Filtering operations
 
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
- For operations on numeric, date or enumerated fields, the parameters with the suffixes `.(gte|gt|lte|lt)$` need to be defined, which should be used as comparators for “greater—equal to, greater than, smaller—equal to, smaller than” respectively. Only the parameters needed for given field should be defined e.g., with `.gte` and `.lte` suffixes only.


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



## 9. Architecture Headers

With the aim of standardizing the request observability and traceability process, common headers that provide a follow-up of the E2E processes should be included. The table below captures these headers.

| Name           | Description                                   | Type     | Location         | Required by API Consumer | Required in OAS Definition | 	Example                              | 
|----------------|-----------------------------------------------|----------|------------------|--------------------------|----------------------------|---------------------------------------|
| `x-correlator` | 	Service correlator to make E2E observability | 		String | Request/Response | No                       | Yes                        | 	b4333c46-49c0-4f62-80d7-f0ef930f1c46 |

When the API Consumer includes the "x-correlator" header in the request, the API provider must include it in the response with the same value that was used in the request. Otherwise, it is optional to include the "x-correlator" header in the response with any valid value. Recommendation is to use UUID for values.


In notification scenarios (i.e., POST request sent towards the listener indicated by `sink` address),
the use of the "x-correlator" is supported for the same aim as well.
When the API request includes the "x-correlator" header,
it is recommended for the listener to include it in the response with the same value as was used in the request.
Otherwise, it is optional to include the "x-correlator" header in the response with any valid value.

NOTE: HTTP headers are case-insensitive. The use of the naming `x-correlator` is a guideline to align the format across CAMARA APIs. 


## 10. Security

One of the key points in the API definition process is to specify and validate the security needs that will be maintained to guarantee data integrity and access control. There are multiple ways to secure a RESTful API, e.g. basic authentication, OAuth2, OIDC, etc., but one thing is for sure: RESTful APIs should be stateless, so authentication/authorization requests should not rely on cookies or sessions. Instead, each API request must come with some form of authentication credentials that must be validated on the server for each request.

The basic idea in terms of security is
to understand that various types of data will require different levels of security.
This depends on the confidentiality of the data
you are trying to get and the level of trust between the API Provider and the consumer.The [CAMARA Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md) defines Security and Interoperability rules and recommendations for Camara e.g.,
details on OIDC and CIBA. 
The CAMARA Security and Interoperability Profile is maintained by the [Identity and Consent Management Working Group](https://github.com/camaraproject/IdentityAndConsentManagement).

### 10.1 API REST Security

<font size="3"><span style="color: blue"> REST security design principles </span></font>
The document "The Protection of Information in Computer Systems", by Jerome Saltzer and Michael Schroeder, outlines eight design principles to secure information in computer systems, which are listed and elaborated below:

1. **Least privilege**. An entity should only have the set of permissions necessary to perform the actions for which it is authorized, and no more. Permissions can be added as needed and should be revoked when no longer in use.
2. **Fail-safe defaults**. A user's default level of access to any system resource should be "denied" unless "permission" has been explicitly granted.
3. **Mechanism economics**. The design should be as simple as possible. All component interfaces and interactions between them should be simple enough to understand.
4. **Full mediation**. A system must validate access rights to all of its resources to ensure that they are allowed and must not rely on the cached permissions array. If the level of access to a certain resource is revoked, but that is not reflected in the permissions matrix, it would violate security.
5. **Open Design**. This principle underlines the importance of building a system in an open way, without secret and confidential algorithms.
6. **Separation of privileges**. Granting permissions to an entity should not be based purely on a single condition, a combination of conditions based on a resource type is a better idea.
7. **Least Common Mechanism**. It refers to the risk of sharing state between different components. If one can corrupt the shared state, then it can corrupt all other components that depend on it.
8. **Psychological acceptance**. This principle states that the security mechanisms must not make the resource more difficult to access than if the security mechanisms were not present. In short, security should not worsen the user experience (restfulapi.net,2021)


<font size="3"><span style="color: blue"> Good practices to secure REST APIs </span></font>

The following points can serve as a checklist to design the security mechanism of the REST APIs.

1. **Simple Management**. 
   Securing only the APIs that need to be secure. Any time the more complex solution is made "unnecessarily", it is also likely to leave a hole. 
2. **HTTPs must be always used**. 
   TLS ensures the confidentiality of the transported data and that the server's hostname matches the server's SSL certificate.
   - If HTTP 2 is used to improve performance, you can even send multiple requests over a single connection, this way you will avoid the complete overhead of TCP and SSL on later requests.

3. **Using hash password**. 
Passwords should never be sent in API bodies,
   but if it is necessary it must be hashed to protect the system
   (or minimize damage) even if it is compromised in some hacking attempts.
   There are many hashing algorithms that can be really effective for password security,
   for example, PBKDF2, bcrypt and scrypt algorithms.

4. **Information must not be exposed in the URLs**
Usernames, passwords, session tokens, and API keys should not appear in the URL, as this can be captured in web server logs, making them easily exploitable. For example, this URL (```https://api.domain.com/user-management/users/{id}/someAction?apiKey=abcd123456789```) exposes the API key. Therefore, never use this kind of security.

5. **Authentication and authorization must be considered**
   Camara uses the authentication and authorization protocols and flows as described in the [Camara Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md).
  
6. **Add request time flags should be considered**. 
Along with other request parameters, a request timestamp can be added as a custom HTTP header in API requests.
   The server will compare the current timestamp with the timestamp of the request
   and will only accept the request if it is within a reasonable time frame
   (1–2 minutes maybe).
   - This will prevent very basic replay attacks from people trying to hack your system without changing this timestamp.

7. **Entry params validation**
 Validates the parameters of the request in the first step before it reaches the application logic.
   Put strong validation checks and reject the request immediately if validation fails.
   In the API response,
   send relevant error messages and an example of the correct input format to improve the user experience.

### 10.2 Security Implementation
The security implemented in an API can be divided into three different layers: i) channel security; ii) access security; and iii) data security.


<font size="3"><span style="color: blue"> Channel security </span></font>

The API must ensure that the channel where the consumer and the API will exchange information is secure.

<u>a) TLS and mutual authentication</u><br>
As for today,
it is commonly agreed that all communications over the Internet must be done via secure HTTP (HTTPS)
using Transport Layer Security (TLS) to generate a secure and recorded communication channel.
In some cases, the TLS channel must be more strictly added to a mutual authentication process to identify both actors.

Protect communications with TLS is mandatory for all APIs. Any API that accepts requests without TLS will not be published to the API Manager. The TLS version to use for APIs is TLS 1.2 (for compatibility) and TLS 1.3 (for security and because it is the latest version available). The API Manager should not accept requests made with some older versions of TLS. 

In case the request does not use the proper TLS, the API should send an HTTP 403 (Forbidden) code with the corresponding response body.

<u>b) Certificate Chain Validation</u><br>
When establishing a TLS with mutual authentication, the API must validate that the consumer's certificate is validated by one of the allowed CAs.

In case the request does not use the proper TLS, the API should send an HTTP 401 (Unauthorized) code with the corresponding response body.

<u>c) Recommended Ciphers</u><br>
These include:
- `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`
- `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384`
- `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`
- `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`



<font size="3"><span style="color: blue"> Access security </span></font>

The API must ensure that the consumer is known and can access the requested resources.

<u>a) OAuth2</u><br>

All APIs must be protected by the OAuth2 Framework.
All API requests must include an HTTP header called "Authorization" with a valid OAuth2 access token.

The following controls will be performed on the access token:
- **Check if the access token is still valid**. If it is expired or revoked, the API will return an HTTP 401 (Unauthorized) code.
- **Check if the access token was created to be used by the requester**. Otherwise, the API will return an HTTP 401 (Unauthorized) code.
- **Check the scope of the access token**, if it is expired or revoked, the API will return an HTTP 403 (Forbidden) code.


<u>b) Scopes</u><br>

The scopes allow defining the permission scopes that a system or a user has on a resource, ensuring that they can only access the parts they need and not have access to more. These restrictions are done by limiting the permissions that are granted to OAuth2 tokens.

Scopes should be represented as below for all Camara APIs except the APIs that offer explicit event subscriptions:
- API Name: qod, address-management, numbering-information...
- Protected Resource: sessions, orders, billings…
- Grant-level, action on resource: read, write…

For e.g. qod:sessions:read

The APIs that offer explicit event subscriptions must have a way
to reflect which event types are being subscribed to when a subscription create request is made.
This will impact how consent management is handled for these APIs. 

Scopes should be represented as below for APIs that offer explicit event subscriptions with action read and delete:
 
- API Name: device-roaming-subscriptions
- Grant-level, action on resource: read, delete
This type of formulation is not needed for the creation action.

For e.g., device-roaming-subscriptions:read 
  
The format to define scopes for explicit subscriptions with action creation,
includes the event type in its formulation to ensure that consent is managed at the level of subscribed event types.
Scopes should be represented as below for APIs that offer explicit event subscriptions with action create:

- API Name: device-roaming-subscriptions
- Event-type: org.camaraproject.device-roaming-subscriptions.v0.roaming-on 
- Grant-level: action on resource: create

For e.g., device-roaming-subscriptions:org.camaraproject.device-roaming-subscriptions.v0.roaming-on:create
  
To correctly define the scopes, when creating them, the following recommendations should be taken:
- **Appropriate granularity**. Scopes should be granular enough to match the types of resources and permissions you want to grant.
- **Use a common nomenclature for all resources**.  Scopes must be descriptive names and that there is no conflict between the different resources.
- **Use the kebab-case nomenclature** to define API names, resources, and scope permissions.
- **Use ":" a separator** between API name, protected resources, event-types and grant-levels for consistency.

See section [11.6 Security Definition](#116-security-definition) for detailed guidelines on how to define scopes and other security-related properties in an OpenAPI file.


<font size="3"><span style="color: blue"> Data security </span></font>

The API must ensure that the information sent is as expected and has not been altered by possible attackers.

<u>a) Headers Validation</u><br>

An attacker can collect information from an API by sending malicious data via headers, so the API must verify that:

1.)	API must receive supported headers only. 

```
HEADER.HACK: SELECT* FROM USERS;
Authorization: Bearer 7894df-ds8f7-sdf84-sdf878u
````

2.) Supported headers must have values and longitudes agreed.

```
Authorization: INSERT INTO …

To avoid this, validate that the "Authorization" header is JWT type and consists of three concatenated Base64url-encoded strings, separated by dots (.)
```

If a header contains a malicious value or an unaccepted header is received, the API should send an HTTP 400 response.

<u>b) Response body validation</u><br>

A more common way to attack an API is to send incorrect values or malicious codes within the data sent in the request to collect relevant information from internal services. Mainly, the APIs do not know if the transmitted data is valid or not, so in the end, the malicious data can navigate to the backend and cause serious problems.

To avoid these undesirable situations, the APIs can carry out a previous control of the payload structure. These validations are performed using JSON definitions with a description of the JSON structure, fields, and value formats in this payload.

In case the payload does not follow these definitions, the API must send an HTTP 400 response.

<u>c) Do not repudiate</u><br>

Sometimes the attacker just wants to modify the payload values to change the behavior of the Customer Service Provider ecosystem to their advantage. For example, if you are running a payment, you can modify the payment payload to change the account id to your own account. This will not change either the structure or the value format of the payload.

In these situations, it is mandatory to require the consumer to send the payload in JWT format, signed with one of the allowed consumer signing certificates.

The API must validate the signature of the JWT in the payload following next requirements:
- The API must validate that the certificate used by the consumer is accepted by one of the allowed CAs (see Certificate Chain Validation sections for a list of accepted CAs).
- Validate that the payload has not been modified during its transmission. Below options should be checked:
  - Encryption/decryption of the JWT signature using the appropriate consumer public key. The JWT is encoded in Base64.
  - Making sure that the decrypted and decrypted signature has the following String value ("`JWT_Header.JWT_Payload`")
  - Making sure that the JWT payload has the same structure and values as the decrypted part of "`JWT_Signature`".


## 11. Definition in OpenAPI

API documentation helps customers integrate with the API by explaining what it is and how to use it. All APIs must include documentation for the developer who will consume your API.

API documentation usually consists of:
- Conceptual information to introduce clients to the API and the domain.
- Practical information to help customers get involved with the API.
- Reference information to inform customers of every detail of your API.

Below considerations should be checked when an API is documented:
- The API functionalities must be implemented following the specifications of the [Open API version 3.0.3](https://spec.openapis.org/oas/v3.0.3) using `api-name` as the filename and the `.yaml` or `.json` file extension.
- The API specification structure should have the following parts:
   -	General information ([Section 11.1](#111-general-information))
   -  Published Routes ([Section 11.2](#112-published-routes))
   -  Request Parameters ([Section 11.3](#113-request-parameters))
   -  Response Structure ([Section 11.4](#114-response-structure))
   -  Data Definitions ([Section 11.5](#115-data-definitions))
   -  Security Schemes ([Section 11.6](#116-security-definition))
- To avoid issues with implementation using Open API generators:
  - Reserved words must not be used in the following parts of an API specification:
    - Path and operation names
    - Path or query parameter names
    - Request and response body property names
    - Security schemes
    - Component names
    - OperationIds
  - A reserved word is one whose usage is reserved by any of the following Open API generators:
    - [Python Flask](https://openapi-generator.tech/docs/generators/python-flask/#reserved-words)
    - [OpenAPI Generator (Java)](https://openapi-generator.tech/docs/generators/java/#reserved-words)
    - [OpenAPI Generator (Go)](https://openapi-generator.tech/docs/generators/go/#reserved-words)
    - [OpenAPI Generator (Kotlin)](https://openapi-generator.tech/docs/generators/kotlin/#reserved-words)
    - [OpenAPI Generator (Swift5)](https://openapi-generator.tech/docs/generators/swift5#reserved-words)

### 11.1 General Information

This part must include the following information:
- API title with public name.
- A concise overview outlining the primary functions of the API.
- API Version in the format defined in [Chapter 5. Versioning](#5-versioning)
- Licence information (name, website…)
- API server and base URL
- Global `tags` object if tags are used for API operations

#### Info object

 
The `info` object shall have the following content:

```yaml
info:
  # title without "API" in it, e.g. "Number Verification"
  title: Number Verification
  # description explaining the API, part of the API documentation 
  # text explaining how to fill the "Authorization and authentication" - see section 11.6
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
  # CAMARA Commonalities version - x.y.z
  x-camara-commonalities: 0.4.0
```

The `termsOfService` and `contact` fields are optional in OpenAPI specification and may be added by API Providers documenting their APIs.

The extension field `x-camara-commonalities` indicates a version of CAMARA Commonalities guidelines that given API specification adheres to.


#### Servers object

The `servers` object shall have the following content:

```yaml
servers:
  # apiRoot variable and the fixed base path containing <api-name> and <api-version> as defined in chapter 5  
  - url: {apiRoot}/quality-on-demand/v2
    variables:
      apiRoot:
        default: http://localhost:9091
        description: API root, defined by the service provider, e.g. `api.example.com` or `api.example.com/somepath`
```
If more than one server object instance is listed, the `servers[*].url` property of each instance must have the same string for the `api-name` and `api-version`'.

### 11.2 Published Routes

This part must contain the list of published functions, with the following description:
- URI functionality.
- HTTP Methods. For each one, the following shall be included:
   - Functionality summary.
   - Functionality method description.
   - Optionally `tags` object for each API operation - Title Case is the recommended style for tag names.
   - Request param list, making reference to "Request params" part.
   - Supported responses list, describing success and errors cases.
   - Allowed content type (“application/json”, “text/xml”…)

### 11.3 Request Parameters

This part contains a list of expected payload requests, if any. This description should have the following items:
- Parameter name, used to reference it in other sections
- Parameter description
- Parameter place (header, route…)
- Type (basic types like strings, integers, complex objects, ...)
- Required field or optional flag


### 11.4 Response Structure

This part describes the list of possible messages returned by the API. It also includes the description of the error response objects:
- Name of the response object, used to refer to it in other sections.
- Response object description.
- Object type (basic types like string, integer... or even more complex objects defined in the "Data definition" part...)
- Allowed content type (“application/json”, “text/xml”…)
- Metadata links (HATEOAS)



### 11.5 Data Definitions

This part captures a detailed description of all the data structures used in the API specification. For each of these data, the specification must contain:
- Name of the data object, used to reference it in other sections.
- Data type (String, Integer, Object…).
- If the format of a string is date-time following sentence must be present in the description: `It must follow [RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) and must have time zone. Recommended format is yyyy-MM-dd'T'HH:mm:ss.SSSZ (i.e. which allows 2023-07-03T14:27:08.312+02:00 or 2023-07-03T12:27:08.312Z)`
- If the data type is an object, list of required properties.
- List of properties within the object data, including:
   - Property name
   - Property description
   - Property type (String, Integer, Object …)
   - Other properties by type:
      - String ones: min and max longitude
      - Integer ones: Format (int32, int64…), min value.


In this part, the error response structure must also be defined following the guidelines in [Chapter 6. Error Responses](#6-error-responses).



#### 11.5.1 Usage of discriminator
As mentioned in OpenAPI doc [here](https://spec.openapis.org/oas/v3.0.3#discriminator-object) usage of discriminator may
simplify serialization/deserialization process and so reduce resource consumption.

##### Inheritance

The mappings section is not mandatory in discriminator, by default ClassName are used as values to populate the property. You can use mappings to restrict usage to a subset of subclasses.
When it's possible, use Object Name as a key in the mapping section. This will simplify the work of providers and consumers who use OpenAPI code generators.

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
To help usage of a Camara object from strongly typed languages, prefer to use inheritance than polymorphism ... Despite this, if you have to use it apply the following rules:

    - objects containing oneOf or anyOf section MUST include a discriminator defined by a propertyName
    - objects involved in oneOf / anyOf section MUST include the property designed by propetyName

The following sample illustrates this usage.

``` yaml 
    IpAddr:
      oneOf:
        - $ref: '#/components/schemas/Ipv6Addr'
        - $ref: '#/components/schemas/Ipv4Addr'
      discriminator:
        propertyName: objectType <-- objectType property MUST be present in the objects referenced in oneOf

    Ipv4Addr: <-- object involved in oneOf MUST include the objectype property
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

    Ipv6Addr: <-- object involved in oneOf MUST include the objectype property
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

When IpAddr is used in a payload, the property objectType MUST be present to indicate which schema to use

``` json
{ 
    "ipAddr": {
        "objectType": "Ipv4Addr",   <-- objectType indicates to use Ipv4Addr to deserialize this IpAddr
        "address": "192.168.1.1",
        ...
    }    
}
```

### 11.6 Security definition

In general, all APIs must be secured to ensure who has access to what and for what purpose.
Camara uses OIDC and CIBA for authentication and consent collection and to determine whether the user has,
e.g. opted out of some API access.

The [Camara Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md#purpose) defines that a single purpose is encoded in the list of scope values. The purpose values are defined by W3C Data Privacy Vocabulary as indicated in the [Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md#purpose-as-a-scope).

#### OpenAPI security schemes definition

[Security schemes](https://spec.openapis.org/oas/v3.0.3#security-scheme-object) express security in OpenAPI. 
Security can be expressed for the API as a whole or for each endpoint.

As specified in [Use of openIdConnect for securitySchemes](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#use-of-openidconnect-for-securityschemes), all Camara OpenAPI files must include the following scheme definition, with an adapted `openIdConnectUrl` in its components section. The schema definition is repeated in this document for illustration purposes, the correct format must be extracted from the link above.

```yaml
components:
  securitySchemes:
    openId:
      type: openIdConnect
      openIdConnectUrl: https://example.com/.well-known/openid-configuration
```

The key of the security scheme is arbitrary in OAS, but convention in CAMARA is to name it `openId`.

#### Expressing Security Requirements

Security requirements of an API are expressed in OpenAPI through [Security Requirement Objects](https://spec.openapis.org/oas/v3.0.3#security-requirement-object).

The following is an example of how to use the `openId` security scheme defined above as described in [Use of security property](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#use-of-security-property):

```yaml
paths:
  {path}:
    {method}:
      ...
      security:
        - openId:
            - {scope}
```

The name `openId` must be same as defined in the components.securitySchemes section.

#### Mandatory template for `info.description` in CAMARA API specs

The documentation template available in [CAMARA API Specification - Authorization and authentication common guidelines](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#mandatory-template-for-infodescription-in-camara-api-specs) must be used as part of the authorization and authentication API documentation in the `info.description` property of the CAMARA API specs.

#### 11.6.1 Scope naming

##### APIs which do not deal with explicit subscriptions

Regarding scope naming for APIs, which do not deal with explicit subscriptions, the guidelines are:

* Define a scope per API operation with the structure:

`api-name:[resource:]action`

where

* `api-name` is the API name specified as the base path, prior to the API version, in the `servers[*].url` property. For example, from `/location-verification/v0`, it would be `location-verification`.

* `resource` is optional. For APIs with several `paths`, it may include the resource in the path. For example, from `/qod/v0/sessions/{sessionId}`, it would be `sessions`.

* `action`: There are two cases:
  - For POST operations with a verb, it will be the verb. For example, from `POST /location-verification/v0/verify`, it would be `verify`.
    - For endpoints designed as POST but with underlying logic retrieving information, a CRUD action `read` may be added. However, if it is a path with a single operation, and it is not expected to have more operations on it, the CRUD action is not necessary.
  - For CRUD operations on a resource in paths, it will be one of:
    - `create`: For operations creating the resource, typically `POST`.
    - `read`: For operations accessing to details of the resource, typically `GET`.
    - `update`: For operations modifying the resource, typically `PUT` or `PATCH`.
    - `delete`: For operations removing the resource, typically `DELETE`.
    - `write` : For operations creating or modifying the resource, when differentiation between `create` and `update` is not needed.
     
* Eventually we may need to add a level to the scope, such as `api-name:[resource:]action[:detail]`, to deal with cases when only a set of parameters/information has to be allowed to be returned. Guidelines should be enhanced when those cases happen.
###### Examples

| API                   | path          | method | scope                                             |
|-----------------------|---------------|--------|---------------------------------------------------|
| location-verification | /verify       | POST   | `location-verification:verify`                    |
| qod                   | /sessions     | POST   | `qod:sessions:create`, or<br>`qod:sessions:write` |
| qod                   | /qos-profiles | GET    | `qod:qos-profiles:read`                           |

<br>

##### APIs which deal with explicit subscriptions

Regarding scope naming for APIs, which deal with explicit subscriptions, the guidelines propose some changes as compared to the above format, and this is described below:

Scopes should be represented as below for APIs that offer explicit event subscriptions with action read and delete, for example:

- API Name: `device-roaming-subscriptions`
- Grant-level, action on resource: `read`, `delete` 

results in scope: `device-roaming-subscriptions:read`.
This type of formulation is not used for the creation action.

The format to define scopes for explicit subscriptions with action creation,
includes the event type in its formulation to ensure that consent is managed at the level of subscribed event types.
Scopes should be represented as below for APIs that offer explicit event subscriptions with action create, for example:

- API Name: `device-roaming-subscriptions`
- Event-type: `org.camaraproject.device-roaming-subscriptions.v0.roaming-on`
- Grant-level: action on resource: `create`

makes scope name: `device-roaming-subscriptions:org.camaraproject.device-roaming-subscriptions.v0.roaming-on:create`.

##### API-level scopes (sometimes referred to as wildcard scopes in CAMARA)

The decision on the API-level scopes was made within the [Identity and Consent Management Working Group](https://github.com/camaraproject/IdentityAndConsentManagement) and is documented in the design guidelines to ensure the completeness of this document. 
The scopes will always be those defined in the API Specs YAML files. Thus, a scope would only provide access to all endpoints and resources of an API if it is explicitly defined in the API Spec YAML file and agreed in the corresponding API subproject. 


### 11.7 Resource access restriction 

In some CAMARA APIs there are functions to create resource (via POST) and then later query them via id and/or list (with GET) or delete them (via DELETE). For example we have sessions, payments, subscriptions, etc..

For the GET and DELETE operations we must restrict the resource(s) targeted depending on the information provided in the request. Basically we consider 2 filters:
* API client (aka ClientId)
* access token

| Operation |  3-legged access token is used | 2-legged access token is used |
|-----------|--------------------------------|-------------------------------|
| GET/{id} | - The resource queried must have been created for the end user associated with the access token. <br> - The resource queried must have been created by the same API client given in the access token. | - The resource queried must have been created by the same API client given in the access token. |
| GET/ | - Return all resource(s) created by the API consumer that are associated with both the end user identified by the access token and the same API client given in the access token. | - Return all resource(s) created by the same API client given in the access token. |
| DELETE/{id} | - The resource to be deleted must have been created for the end user associated with the access token. <br> - The resource to be deleted must have been created by the same API client given in the access token. | - The resource to be deleted must have been created by the same API client given in the access token. |



## 12. Subscription, Notification & Event

To provide event-based interaction, CAMARA API could provide capabilities for subscription & notification management.
A subscription allows an API consumer to request event notification reception at a given URL (callback address) for a specific context.
A notification is the publication at the listener address about an occurred event.
Managed event types are explicitly defined in CAMARA API OAS.

### 12.1 Subscription

We distinguish two types of subscriptions:
- Instance-based subscription (implicit creation)
- Resource-based subscription (explicit creation)

#### Instance-based (implicit) subscription

An instance-based subscription is a subscription indirectly created, additionally to another resource creation.
For example, for a Payment request (in Carrier Billing API), in the `POST/payments`,
the API consumer could request to get event notification about **this** Payment request processing update.
The subscription is not an autonomous entity,
and its lifecycle is linked to the managed entity (the Payment resource in this case).
The subscription terminates with the managed entity.

Providing this capability is optional for any CAMARA API depending on UC requirements.

If this capability is present in CAMARA API, the following attributes **must** be used in the POST request :

| attribute name | type   | attribute description                                                                                                                                                                                                                                                                                       | cardinality |
|----------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------| 
| sink           | string | https callback address where the notification must be POST-ed                                                                                                                                                                                                                                               | mandatory   |
| sinkCredential | object | Sink credential provides authentication or authorization information necessary to enable delivery of events to a target. In order to be updated in future this object is polymorphic. See detail below. It is RECOMMENDED for subscription consumer to provide credential to protect notification endpoint. | optional    |

Several types of `sinkCredential` could be available in the future, but for now only access token credential is managed.

``sinkCredential`` attributes table (must be access token for now):

| attribute name       | type             | attribute description                                                          | cardinality |
|----------------------|------------------|--------------------------------------------------------------------------------|-------------| 
| credentialtype       | string           | Type of the credential - MUST be set to `ACCESSTOKEN` for now                  | mandatory   |
| accessToken          | string           | Access Token granting access to the POST operation to create notification      | mandatory   |
| accessTokenExpireUtc | string date-time | An absolute UTC instant at which the access token shall be considered expired. | mandatory   |
| accessTokenType      | string           | Type of access token - MUST be set to `Bearer` for now                         | mandatory   |


##### Instance-based (implicit) subscription example

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




#### Resource-based (explicit) subscription

A resource-based subscription is an event subscription managed as a resource. This subscription is explicit. An API endpoint is provided to request subscription creation.  As this event subscription is managed as an API resource, it is identified and operations to search, retrieve and delete it must be provided.

Note: It is perfectly valid for a CAMARA API to have several event types managed.
The subscription endpoint will be unique,
but the 'eventType' attribute is used to distinguish distinct events subscribed.

To ease developer adoption,
the pattern for Resource-based event subscription should be consistent with all API providing this feature.

CAMARA subscription model leverages **[CloudEvents](https://cloudevents.io/)** and is based on release [0.1-wip](https://github.com/cloudevents/spec/blob/main/subscriptions/spec.md) as it is a vendor-neutral specification for defining the format of subscription. A generic neutral CloudEvent subscription OpenAPI specification is available in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents/) directory (event-subscription-template.yaml).

To ensure consistency across Camara subprojects, it is necessary that explicit subscriptions are handled within separate API/s. It is mandatory to append the keyword "subscriptions" at the end of the API name. For e.g. device-roaming-subscriptions.yaml

##### Operations
Four operations must be defined:

| operation | path                              | description                                                                                                                                                                                            |
|-----------|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| POST      | `/subscriptions`                  | Operation to request an event subscription. (*)                                                                                                                                                        |
| GET       | `/subscriptions`                  | Operation to retrieve a list of event subscriptions - could be an empty list.  e.g. `GET /subscriptions?type=org.camaraproject.device-roaming-subscriptions.v1.roaming-status&expiresAt.lt=2023-03-17` |
| GET       | `/subscriptions/{subscriptionId}` | Operation to retrieve an event subscription (**)                                                                                                                                                       |
| DELETE    | `/subscriptions/{subscriptionId}` | Operation to delete an event subscription (***)                                                                                                                                                        |

Notes:

(*) As the subscription could be created synchronously or asynchronously,
both status codes 201 and 202 must be described in the OpenAPI specification.
 
(**) If the `GET /subscriptions/{subscriptionId}` is not able to retrieve a recently created subscription in asynchronous mode, a 404 code is sent back.
  
(***) As the subscription deletion could be handled synchronously or asynchronously,
both status codes 202 and 204 must be described in the OpenAPI specification.

Note on the operation path:
The recommended pattern is to use `/subscriptions` path for the subscription operation.
But an API design team, for a specific case, can append `/subscriptions` path with a prefix
(e.g. `/roaming/subscriptions` and `/connectivity/subscriptions`).
The rationale for using this alternate pattern should be explicitly provided
(e.g. the notification source for each of the supported events may be completely different,
in which case, separating the implementations is beneficial). 

##### Rules for subscriptions data minimization 

These rules apply for subscription with device identifier
- If 3-legged access token is used, the POST and GET responses must not provide any device identifier.
- If 2-legged access token is used, the presence of a device identifier in the response is mandatory and should be the same identifier type than the one provided in the request.

Application of data minimization design must be considered by the API Sub Project for event structure definition.

##### Subscriptions data model
The following table provides `/subscriptions` attributes

| name           | type               | attribute description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | cardinality                  |
|----------------|--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------| 
| protocol       | string             | Identifier of a delivery protocol. **Only** `HTTP` **is allowed for now**.                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Mandatory                    |
| sink           | string             | The address to which events shall be delivered, using the HTTP protocol.                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | mandatory                    |
| sinkCredential | object             | Sink credential provides authorization information necessary to enable delivery of events to a target. In order to be updated in future this object is polymorphic. See detail below. To protect the notification endpoint providing sinkCredential is RECOMMENDED. <br> The sinkCredential must **not** be present in `POST` and `GET` responses.                                                                                                                                                                                                                                                                    | optional                     |
| types          | string             | Type of event subscribed. This attribute **must** be present in the `POST` request. It is required by API project to provide an enum for this attribute. `type` must follow the format: `org.camaraproject.<api-name>.<api-version>.<event-name>` with the `api-version` with letter `v` and the major version like  ``org.camaraproject.device-roaming-subscriptions.v1.roaming-status`` - Note: An array of types could be passed **but as of now only one value MUST passed**. Use of multiple value will be open later at API level. | mandatory                    |
| config         | object             | Implementation-specific configuration parameters needed by the subscription manager for acquiring events. In CAMARA we have predefined attributes like ``subscriptionExpireTime``, ``subscriptionMaxEvents`` or ``initialEvent``. See detail below.                                                                                                                                                                                                                                                                                      | mandatory                    |
| id             | string             | Identifier of the event subscription - This attribute must not be present in the POST request as it is provided by API server                                                                                                                                                                                                                                                                                                                                                                                                            | mandatory in server response |
| startsAt       | string - date-time | Date when the event subscription will begin/began. This attribute must not be present in the `POST` request as it is provided by API server. It must be present in `GET` endpoints                                                                                                                                                                                                                                                                                                                                                       | optional                     |
| expiresAt      | string - date-time | Date when the event subscription will expire. This attribute must not be present in the `POST` request as it is provided (optionally) by API server. This attribute must be provided by the server if subscriptionExpireTime is provided in the request and server is not able to handle it.                                                                                                                                                                                                                                                                                                                                                                                 | optional                     |
| status         | string             | Current status of the subscription - Management of Subscription state engine is not mandatory for now. Note: not all statuses may be considered to be implemented. See below status table.                                                                                                                                                                                                                                                                                                                                               | optional                     |



``sinkCredential`` attributes table (must be only access token for now):

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
Remark: This action will trigger a subscription-ends event with terminationReason set to "ACCESS_TOKEN_EXPIRED"
(probably this notification will also get the EXPIRED status answer). 

`config` attributes table:


| attribute name         | type               | attribute description                                                                                                                                                                                                                                                                                                               | cardinality |
|------------------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------| 
| subscriptionMaxEvents  | integer            | Identifies the maximum number of event reports to be generated (>=1) - Once this number is reached, the subscription ends. Up to API project decision to keep it.                                                                                                                                                                   | optional    |
| subscriptionDetail     | object             | Object defined for each event subscription depending on the event. This is in this object that for example the device identifier will be provided (see example below).                                                                                                                                                              | mandatory   |
| subscriptionExpireTime | string - date-time | The subscription expiration time (in date-time format) requested by the API consumer. Up to API project decision to keep it.                                                                                                                                                                                                        | optional    |
| initialEvent           | boolean            | Set to true by API consumer if consumer wants to get an event as soon as the subscription is created and current situation reflects event request. Example: Consumer request Roaming event. If consumer sets initialEvent to true and device is in roaming situation, an event is triggered. Up to API project decision to keep it. | optional    |


**Note** on combined usage of initialEvent and subscriptionMaxEvents: 
Unless explicitly decided otherwise by the API Sub Project, if an event is triggered following initialEvent set to `true`, this event will be counted towards subscriptionMaxEvents (if provided).
It is recommended to provide this clarification in all subscription APIs featuring subscriptionMaxEvents and initialEvent.

**Subscription status value table**:

Managing subscription is a draft feature, and it is not mandatory for now. An API project could decide to use/not use it. A list of status is provided for global consistency.

| status               | definition                                                                                                                                                                                                                                                            |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ACTIVATION_REQUESTED | Subscription creation (POST) is triggered but subscription creation process is not finished yet.                                                                                                                                                                      |
| ACTIVE               | Subscription creation process is completed. Subscription is fully operative.                                                                                                                                                                                          |
| INACTIVE             | Subscription is temporarily inactive, but its workflow logic is not deleted. INACTIVE could be used when an user initially provided consent for the event monitor and then later denied this consent. For now we did not provide capability to reactive subscription. |
| EXPIRED              | Subscription is ended (no longer active). This status applies when subscription is ended due to max event reached, expire time reached or access token indicated for notification security (i.e. sinkCredential) expiration time reached.                             |
| DELETED              | Subscription is ended as deleted (no longer active). This status applies when subscription information is kept (i.e. subscription workflow is no longer active but its meta-information is kept).                                                                     |


##### Error definition for resource-based (explicit) subscription

Error definition described in this guideline applies for subscriptions.

The Following Error codes must be present:
* for `POST`: 400, 401, 403, 409, 415, 429, 500, 503
* for `GET`: 400, 401, 403, 500, 503
* for `GET .../{subscriptionId}`: 400, 401, 403, 404, 500, 503
* for `DELETE`: 400, 401, 403, 404, 500, 503

Please see in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents) directory ``event-subscription-template.yaml`` for more information and error examples. 


##### Termination for resource-based (explicit) subscription

4 scenarios of subscription termination are possible (business conditions may apply):

* case1: subscriptionExpireTime has been provided in the request and reached. The operator in this case has to terminate the subscription.
* case2: subscriptionMaxEvents has been provided in the request and reached. The operator in this case has to terminate the subscription.
* case3: subscriber requests the `DELETE` operation for the subscription (if the subscription did not have a subscriptionExpireTime or before subscriptionExpireTime expires). 
* case4: subscription ends on operator request. 

It could be useful to provide a mechanism to inform subscriber for all cases. In this case, a specific event type could be used.

_Termination rules regarding subscriptionExpireTime & subscriptionMaxEvents usage_
* When client side providing a `subscriptionExpireTime` and/or `subscriptionMaxEvents` service side has to terminate the subscription without expecting a `DELETE` operation.
* CAMARA does not impose limitations for `subscriptionExpireTime` or `subscriptionMaxEvents` but API providers may enforce limitations and must document them accordingly.
* If both `subscriptionExpireTime` and `subscriptionMaxEvents` are provided, the subscription will end when the first one is reached.
* When none `subscriptionExpireTime` and `subscriptionMaxEvents` are not provided, client side has to trigger a `DELETE` operation to terminate it.
* It is perfectly valid for client side to trigger a DELETE operation before `subscriptionExpireTime` and/or `subscriptionMaxEvents` reached. 


##### Resource-based (explicit) example
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
the two requests should be handled independently & autonomously.
Depending on server implementation, it is acceptable 
when the event occurs that one or two notifications are sent to listener.


### 12.2 Event notification

#### Event notification definition

The API server uses the event notification endpoint to notify the API consumer that an event occurred.

CAMARA event notification leverages **[CloudEvents](https://cloudevents.io/)** and is based on release [1.0.2](https://github.com/cloudevents/spec/releases/tag/v1.0.2) as it is a vendor-neutral specification for defining the format of event data. A generic neutral CloudEvent notification OpenAPI specification is available in Commonalities/artifact directory (notification-as-cloud-event.yaml).

Note: The notification is the message posted on the listener side. 
We describe the notification(s) in the CAMARA API using the `callbacks`. 
From API consumer it could be confusing because this endpoint must be implemented on the business API consumer side.
This notice should be explicitly mentioned in all CAMARA API documentation featuring notifications.

Only Operation POST is provided for event notification and the expected response code is `204`. 
The URL for this `POST` operation must be specified in the API specification as `{$request.body#/sink}`. 
The event notification is represented in the JavaScript Object Notation (JSON) Data Interchange Format ([RFC8259](https://datatracker.ietf.org/doc/html/rfc8259)). Such [CloudEvents representation](https://github.com/cloudevents/spec/blob/main/cloudevents/formats/json-format.md) must use the media type `application/cloudevents+json`.

For consistency across CAMARA APIs, the uniform CloudEvents model must be used with the following rules:

| name            | type              | attribute description                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | cardinality   |
|-----------------|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------| 
| id              | string            | identifier of this event, that must be unique in the source context.                                                                                                                                                                                                                                                                                                                                                                                                                             | mandatory     |
| source          | string - URI      | identifies the context in which an event happened in the specific Provider Implementation. Often this will include information such as the type of the event source, the organization publishing the event or the process that produced the event. The exact syntax and semantics behind the data encoded in the URI is defined by the event producer.                                                                                                                                           | mandatory     |
| type            | string            | a value describing the type of event related to the originating occurrence. For consistency across API we mandate following pattern: `org.camaraproject.<api-name>.<api-version>.<event-name>` with the `api-version` with letter 'v' and the major version like example org.camaraproject.device-roaming-subscriptions.v1.roaming-status                                                                                                                                                        | mandatory     |
| specversion     | string            | version of the specification to which this event conforms - must be "1.0". As design guideline, this field will be modeled as an enum.                                                                                                                                                                                                                                                                                                                                                           | mandatory     |
| datacontenttype | string            | media-type that describes the event payload encoding, must be `application/json` for CAMARA APIs                                                                                                                                                                                                                                                                                                                                                                                                 | optional      |
| subject         | string            | describes the subject of the event - Not used in CAMARA notification.                                                                                                                                                                                                                                                                                                                                                                                                                            | optional      |
| time            | string  date-time | Timestamp of when the occurrence happened. If the time of the occurrence cannot be determined then this attribute MAY be set to some other time (such as the current time) by the CloudEvents producer, however all producers for the same `source` MUST be consistent in this respect. In other words, either they all use the actual time of the occurrence or they all use the same algorithm to determine the value used. (must adhere to CAMARA date-time recommendation based on RFC 3339) | mandatory (*) |
| data            | object            | event notification details payload described in each CAMARA API and referenced by its `type`                                                                                                                                                                                                                                                                                                                                                                                                     | optional (**) |

(*) Note: Attribute  `time` is tagged as optional in CloudEvents specification, but from CAMARA perspective we mandate to value this attributes.

(**) Event data (domain-specific information about the occurrence) are encapsulated within `data` object, its occurrence can be set to mandatory by given CAMARA API and its structure is dependent on each API:

| name           | type   | attribute description                                                              | cardinality |
|----------------|--------|------------------------------------------------------------------------------------|-------------| 
| subscriptionId | string | The event subscription identifier - must be valued for Resource-based subscription | optional    |
| ...            | ...    | Specific attribute(s) related to the notification event                            | ...         |


Note: For operational and troubleshooting purposes it is relevant to accommodate use of `x-correlator` header attribute. API listener implementations have to be ready to support and receive this data.

#### subscription-ends event
Specific event notification type "subscription-ends" is defined to inform listener about subscription termination.

It is used when the `subscriptionExpireTime` or `subscriptionMaxEvents` has been reached, or, if the API server has to stop sending notifications prematurely, or if the subscription request is managed asynchronously by the server and it is not able to provide the service. For this specific event, the `data` must feature `terminationReason` attribute. An enumeration of `terminationReason` is provided in event-subscription-template.yaml (see in [Commonalities/artifacts/camara-cloudevents](/artifacts/camara-cloudevents) directory ``event-subscription-template.yaml``). 

Note: The "subscription-ends" notification is not counted in the `subscriptionMaxEvents`. (for example, if a client request a `subscriptionMaxEvents` to 2, later, received second notification, then a third notification will be sent for "subscription-ends")

#### Error definition for event notification

Error definitions are described in this guideline applies for event notification.

The Following Error codes must be present:
* for `POST`: 400, 401, 403, 500, 503

#### Correlation Management
To manage correlation between the subscription management and the event notification (as these are two distinct operations):
- use `subscriptionId` attribute (in `data` structure in the body) - this identifier is provided in event subscription and could be valued in each event notification. 

Note: There is no normative enforcement to use any of these patterns, and they could be used on agreement between API consumer & providers.

#### Security Considerations

As notification may carry sensitive information, privacy and security constraints have to be considered. CloudEvents specification provides some guidance there: https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md#privacy-and-security

#### Abuse Protection

Any system permitting the registration and delivery of notifications to arbitrary HTTP endpoints holds the potential for abuse. This could occur if someone, either intentionally or unintentionally, registers the address of a system unprepared for such requests, or for which the registering party lacks authorization to perform such registration.

To protect the sender, CloudEvents specification provides some guidance there: https://github.com/cloudevents/spec/blob/main/cloudevents/http-webhook.md#4-abuse-protection

Event Producers shall choose based on their internal security guidelines to implement measures based on the above guidance to ensure abuse protection. For e.g., An event producer might ask the subscriber to pre-register the notification URL at the time of app onboarding. If this registered notification URL doesn't match later with the notification URL in the request, the event producer can choose to reject the request with the relevant error code.


#### Notification examples

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
  "type": "org.camaraproject.api.device-roaming-subscriptions.v1.subscription-ends",
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

## Appendix A (Normative): `info.description` template for when User identification can be from either an access token or explicit identifier

When an API requires a User (as defined by the [ICM Glossary](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-API-access-and-user-consent.md#glossary-of-terms-and-concepts)) to be identified in order to get access to that User's data (as Resource Owner), the User can be identified in one of two ways:
- If the access token is a Three-Legged Access Token, then the User will already have been associated with that token by the API provider, which in turn may be identified from the physical device that calls the `/authorize` endpoint for the OIDC authorisation code flow, or from the `login_hint` parameter of the OIDC CIBA flow (which can be a device IP, phone number or operator token). The `sub` claim of the ID token returned with the access token will confirm that an association with the User has been made, although this will not identify the User directly given that the `sub` will not be a globally unique identifier nor contain PII as per the [CAMARA Security and Interoperability Profile](https://github.com/camaraproject/IdentityAndConsentManagement/blob/main/documentation/CAMARA-Security-Interoperability.md#id-token-sub-claim) requirements.
- If the access token is a Two-Legged Access Token, no User is associated with the token, an hence an explicit identifier MUST be provided. This is typically either a `Device` object named `device`, or a `PhoneNumber` string named `phoneNumber`. Both of these schema are defined in the [CAMARA_common.yaml](/artifacts/CAMARA_common.yaml) artifact. In both cases, it is the User that is being identified, although the `device` identifier allows this indirectly by identifying an active physical device.

If an API provider issues Thee-Legged Access Tokens for use with the API, the following error may occur:
- **Both a Three-Legged Access Token and an explicit User identifier (device or phone number) are provided by the API consumer.**

  Whilst it might be considered harmless to proceed if both identify the same User, returning an error only when the two do not match would allow the API consumer to confirm the identity of the User associated with the access token, which they might otherwise not know. Although this functionality is supported by some APIs (e.g. Number Verification, KYC Match), for others it may exceed the scope consented to by the User.

  In this case, a `422 UNNECESSARY_IDENTIFIER` error code MUST be returned unless the scope of the API allows it to explicitly confirm whether or not the supplied identity matches that bound to the Three-Legged Access Token.

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

- If the subject can be identified from the access token and the optional [`device` object | `phoneNumber` field](*) is also included in the request, then the server will return an error with the `422 UNNECESSARY_IDENTIFIER` error code. This will the case even if the same [ device | phone number ](*) is identified by these two methods, as the server is unable to make this comparison.
```
