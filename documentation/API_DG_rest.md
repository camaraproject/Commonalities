<!-- Generated template with placeholders for chunks -->

# API design guidelines

This document captures guidelines for the API design in CAMARA project. These guidelines are applicable to every API to be worked out under the CAMARA initiative.



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

When the `POST` method is used:
- the resource in the path MUST be a verb (e.g. `retrieve-location` and not `location`) to differentiate from an actual resource creation
- the request body itself MUST be a JSON object and MUST be required, even if all properties are optional

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





