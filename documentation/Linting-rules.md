# CAMARA API Linting Rules Documentation

## Introduction


## 1. Spectral core ruleset

Spectral has a built-in OpenAPI Specification ruleset that can be used to validate OpenAPI files.

With `extends: "spectral:oas"` ("oas" being shorthand for OpenAPI Specification) in the ruleset file to rules for OpenAPI v2 and v3.x, depending on the appropriate OpenAPI version being used (this is automatically detected through formats) is added to the final ruleset.

All the rules in this ruleset are described in [OpenAPI Rules](https://docs.stoplight.io/docs/spectral/4dec24461f3af-open-api-rules).


`extends: [[spectral:oas, off]]` - This avoids running any rules from the extended ruleset as they are disabled. Each rule then can be [enabled individually](https://docs.stoplight.io/docs/spectral/0a73453054745-recommended-or-all#enabling-rules).


### Recommended rules
Spectral's built-in OpenAPI ruleset is a two-tier system: with subset of rules marked as [recommended](https://docs.stoplight.io/docs/spectral/0a73453054745-recommended-or-all#recommended-or-all) to be used by default, and additional rules marked with `recommended: false`.
Recommended rules cover more basic requirements.

### Rule severity

The `severity` keyword is optional in rule definition and can be `error`, `warn`, `info`, `hint`, or `off`.
The default value is `warn`.

### OpenAPI v2 & v3

Rules applying to OpenAPI v2.0, v3.0, and most likely v3.1 - details are described in [Spectral Documentation](https://docs.stoplight.io/docs/spectral/4dec24461f3af-open-api-rules#openapi-v2--v3).

| Name                               | Desc                                                                                 | Recommended | CAMARA use | Spectral severity | CAMARA severity |
|------------------------------------|--------------------------------------------------------------------------------------|-------------|------------|-------------------|-----------------|
| contact-properties                 | contact object is full of the most useful properties: `name`, `url`, and `email`     | No          | No         | Warning           | Warning         |
| duplicated-entry-in-enum           | Each value of an `enum` must be different from one another                           | Yes         | Yes        | Warning           | Warning         |
| info-contact                       | Info object should contain `contact` object                                          | No          | No         | Warning           | Warning         |
| info-description                   | Info object should contain `description` object                                      | Yes         | Yes        | Warning           | Warning         | 
| info-license                       | Info object should contain `license` object                                          | Yes         | Yes        | Warning           | Warning         |
| license-url                        | link to the full text of licence                                                     | Yes         | Yes        | Warning           | Warning         |
| no-$ref-siblings                   | Before OpenAPI v3.1, keywords next to $ref were ignored                              | Yes         | Yes        | Error             | Error           |
| no-eval-in-markdown                | injecting `eval()` JavaScript statements could lead to an XSS attack                 | Yes         | Yes        | Warning           | Warning         |
| no-script-tags-in-markdown         | injecting `<script>` tags could lead to execution of an arbitrary                    | Yes         | Yes        | Warning           | Warning         |
| openapi-tags                       | OpenAPI object should have non-empty `tags` array                                    | No          | No         | Warning           | Warning         |
| openapi-tags-alphabetical          | OpenAPI object should have alphabetical `tags`                                       | No          | No         | Warning           | Warning         |
| openapi-tags-uniqueness            | OpenAPI object must not have duplicated tag names                                    | No          | No         | Error             | Error           |
| operation-description              | Operation `description` must be present and non-empty string                         | Yes         | Yes        | Warning           | Warning         |
| operation-operationId              | Operation must have `operationId`                                                    | Yes         | Yes        | Warning           | Warning         |
| operation-operationId-unique       | Every operation must have a unique operationId                                       | Yes         | Yes        | Error             | Error           |
| operation-operationId-valid-in-url | avoid non-URL-safe characters                                                        | Yes         | Yes        | Warning           | Warning         |
| operation-parameters               | Operation parameters are unique and non-repeating                                    | Yes         | Yes        | Warning           | Warning         |
| operation-singular-tag             | Use just one tag for an operation                                                    | No          | Yes        | Warning           | Warning         |
| operation-success-response         | Operation must have at least one `2xx` or `3xx` response                             | Yes         | Yes        | Warning           | Warning         |
| operation-tags                     | Operation should have non-empty `tags` array                                         | Yes         | Yes        | Warning           | Warning         |
| operation-tag-defined              | Operation tags should be defined in global tags                                      | Yes         | Yes        | Warning           | Warning         |
| path-declarations-must-exist       | Path parameter declarations cannot be empty, ex.`/given/{}` is invalid               | Yes         | Yes        | Warning           | Warning         |
| path-keys-no-trailing-slash        | Keep trailing slashes off of paths                                                   | Yes         | Yes        | Warning           | Warning         |
| path-not-include-query             | Don't put query string items in the path, they belong in parameters with `in: query` | Yes         | Yes        | Warning           | Warning         |
| path-params                        | Path parameters are correct and valid                                                | Yes         | Yes        | Error             | Error           |
| tag-description                    | global tags have description                                                         | No          | No         | Warning           | Warning         |
| typed-enum                         | Enum values should respect the type specifier.                                       | Yes         | Yes        | Warning           | Warning         |

### OpenAPI v3-only
Rules applicable only to OpenAPI v3.0 documents - details are described in [Spectral Documentation](https://docs.stoplight.io/docs/spectral/4dec24461f3af-open-api-rules#openapi-v3-only).

| Name                                 | Desc                                                                                                              | Recommended | CAMARA use | Spectral severity | CAMARA severity |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------|-------------|------------|-------------------|-----------------|
| oas3-api-servers                     | OpenAPI servers must be present and non-empty array                                                               | Yes         | Yes        | Warning           | Warning         |
| oas3-examples-value-or-externalValue | Examples for requestBody or response examples can have an `externalValue` or a `value`, but they cannot have both | Yes         | Yes        | Warning           | Warning         |
| oas3-operation-security-defined      | Operation `security` values must match a scheme defined in the `components.securitySchemes` object.               | Yes         | No         | Warning           | Warning         |
| oas3-parameter-description           | Parameter objects should have a description                                                                       | No          | No         | Warning           | Warning         |
| oas3-schema                          | Validate structure of OpenAPI v3 specification                                                                    | Yes         | Yes        | Warning           | Warning         |
| oas3-server-not-example.com          | Server URL should not point to *example.com*                                                                      | No          | No         | Warning           | Warning         |
| oas3-server-trailing-slash           | Server URL should not have a trailing slash                                                                       | Yes         | Yes        | Warning           | Warning         |
| oas3-unused-component                | Potential unused reusable components entry has been detected                                                      | Yes         | Yes        | Warning           | Warning         |
| oas3-valid-media-example             | Examples must be valid against their defined schema. This rule is applied to *Media Type objects*                 | Yes         | Yes        | Warning           | Warning         |
| oas3-valid-schema-example            | Examples must be valid against their defined schema. This rule is applied to *Schema objects*                     | Yes         | Yes        | Warning           | Warning         |
| oas3-server-variables                | This rule ensures that server variables defined in OpenAPI Specification 3 (OAS3) and 3.1 are valid, not unused   | Yes         | Yes        | Warning           | Warning         |

Note: oas3-operation-security-defined rule is not fully compatible with OpenIdConnect.

## 2. Language
### Spell checking

CAMARA API specification files include inline documentation.

The description attributes should be checked for typos.

_Spectral rule_: [camara-language-spelling](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

### Reduce telco-specific terminology in API definitions

Consider and account for how the API can be fulfilled on a range of network types.
Avoid terms/types specific to a given telco domain - terms should be inclusive beyond mobile network. 

See also [CAMARA Glossary](Glossary.md)


| ❌ &nbsp; Not recommended | 👍  &nbsp; Recommended |
|--------------------------|------------------------|
| `UE`                     | `device`               |
| `MSISDN`                 | `phone number`         |
| `mobile network`         | `network`              |


_Spectral rule_: [camara-language-avoid-telco](/artifacts/linting_rules/.spectral.yml)

*Severity*: `hint`


## 3. API Definition


### Openapi property

CAMARA API Design Guide: 
[5.2. OpenAPI Version](CAMARA-API-Design-Guide.md#52-openapi-version)

The API functionalities must be implemented following the specifications of the **Open API version 3.0.3** 

`/users/{id}`

| ❌ &nbsp; Not recommended | 👍  &nbsp; Recommended |
|--------------------------|------------------------|
| `openapi: 3.0.1`         | `openapi: 3.0.3`       |

_Spectral rule_: [camara-oas-version](/artifacts/linting_rules/.spectral.yml)

*Severity*: `error`

### Info object

CAMARA API Design Guide: 
[5.3. Info Object](CAMARA-API-Design-Guide.md#53-info-object)

Info object must include the following information: API title with public name.

_Spectral rule_: [camara-info−title](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

CAMARA API Design Guide: 
[5.3.3. Version](CAMARA-API-Design-Guide.md#533-version)

Info object must include the following information: API Version in the format: X.Y.Z.

_Spectral rule_: [camara-info−version-format](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn` <br>
❕ Note: The version format may follow "wip", "x.y.z-alpha.n", or "x.y.z-rc.n" for unreleased or pre-release versions.


### Path parameters

CAMARA API Design Guide: 
[5.7.1. Paths](CAMARA-API-Design-Guide.md#571-paths)

The attribute must be identifying itself, it is not enough with "{id}"

`/users/{id}`

| ❌ &nbsp; Not recommended             | 👍  &nbsp; Recommended                   |
|--------------------------------------|------------------------------------------|
| `/users/{id}/documents/{documentId}` | `/users/{userId}/documents/{documentId}` |

_Spectral rule_: [camara-path-param-id](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

The identifier should have a similar morphology on all endpoints. For example, “*xxxxId*”, where *xxx* is the name of the entity it references

| 👍  &nbsp; Recommended                 |
|----------------------------------------|
| `/users/{userId}`                      |
| `/accounts/{accountId}`                |
| `/vehicles/{vehicleId}`                |
| `/users/{userId}/vehicles/{vehicleId}` |

_Spectral rule_: [camara-path-param-id-morphology](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`


### Sensitive data

CAMARA API Design Guide: 
[6.5. POST or GET for transferring sensitive or complex data](CAMARA-API-Design-Guide.md#65-post-or-get-for-transferring-sensitive-or-complex-data) 

Sensitive data (msisdn/imsi) cannot be a path or query parameter.
<br>❕ Note: Needs to list down if we have other sensitive parameters other than MSISDN/IMSI - cf.  *monite-security-no-secrets-in-path-or-query-parameters*


_Spectral rule_: [camara-security-no-secrets-in-path-or-query-parameters](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

### HTTP verbs

CAMARA API Design Guide: 
[5.7.2. Operations](CAMARA-API-Design-Guide.md#572-operations)

A resource has multiple operations identified by HTTP Verbs: GET, PUT, POST, PATCH, DELETE.

_Spectral rule_: [camara-http-methods](/artifacts/linting_rules/.spectral.yml)

*Severity*: `error`

CAMARA API Design Guide: 
[5.7.5. Request bodies](CAMARA-API-Design-Guide.md#575-request-bodies)

'GET' and 'DELETE' http methods MUST NOT accept a 'requestBody' attribute 
<br>❕ Note: https://github.com/team-monite/api-style-guide/blob/main/spectral/monite.section8-requests.yaml

_Spectral rule_: [camara-get-no-request-body](/artifacts/linting_rules/.spectral.yml)

*Severity*: `error`


### Reserved words

CAMARA API Design Guide: 
[5.1. Reserved words](CAMARA-API-Design-Guide.md#51-reserved-words)

To avoid issues with implementation using Open API generators:

    Reserved words must not be used in the following parts of an API specification:
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

_Spectral rule_: [camara-reserved-words](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`


Resource names must not contain the method name: get, put, post, delete, patch.

_Spectral rule_: [camara-resource-reserved-words](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

 
### Descriptions

CAMARA API Design Guide: [5.7.2. Operations](CAMARA-API-Design-Guide.md#572-operations)

Functionality methods must have a description.

_Spectral rule_: [camara-routes-descriptions](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

CAMARA API Design Guide: [5.7.4. Parameters](CAMARA-API-Design-Guide.md#574-parameters)

All parameters must have a description. 

_Spectral rule_: [camara-parameters-descriptions](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

CAMARA API Design Guide: [5.7.6. Responses](CAMARA-API-Design-Guide.md#576-responses) 

All response objects must have a description. 

_Spectral rule_: [camara-response-descriptions](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

CAMARA API Design Guide: [5.8. Components](CAMARA-API-Design-Guide.md#58-components)

All properties within the object must have a description. 

_Spectral rule_: [camara-properties-descriptions](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

CAMARA API Design Guide: [5.7.2. Operations](CAMARA-API-Design-Guide.md#572-operations)
Summary must be defined on each operation, describing with a short summary what the operation does.  
_Spectral rule_: [camara-operation-summary](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

### Usage of discriminator

CAMARA API Design Guide: [2.2.1. Usage of discriminator](CAMARA-API-Design-Guide.md#221-usage-of-discriminator)

When request bodies or response payloads may be one of a number of different schemas (containing `oneOf` or `anyOf` section), a `discriminator` object can be used to aid in serialization, deserialization, and validation. 

_Spectral rule_: [camara-discriminator-use](/artifacts/linting_rules/.spectral.yml)

*Severity*: `hint`
DEPRECATED: this rule generates mainly false positives - its implementation can be rewritten in future

### Casing convention

Spectral core functions: [casing](https://docs.stoplight.io/docs/spectral/cb95cf0d26b83-core-functions#casing) can be used to verify text match a certain case. Available types are:
|name	|sample|
|---|----|
|flat|	verylongname|
|camel|	veryLongName|
|pascal|	VeryLongName|
|kebab|	very-long-name|
|cobol|	VERY-LONG-NAME|
|snake|	very_long_name|
|macro|	VERY_LONG_NAME|


#### Enum

CAMARA API Design Guide: **No clear requirement**

❓ This rule verifies that `enum` fields contain values that follow a specific case convention: `macro`.

_Spectral rule_: [camara-enum-casing-convention](/artifacts/linting_rules/.spectral.yml)

*Severity*: `info`


#### Operation ID

CAMARA API Design Guide: [5.7.2. Operations](CAMARA-API-Design-Guide.md#572-operations)


>   OperationIds are defined in lowerCamelCase: For example: `helloWorld`

Operation ids should follow a specific case convention: `camel` case.

_Spectral rule_: [camara-operationid-casing-convention](/artifacts/linting_rules/.spectral.yml)

*Severity*: `error`

#### Path parameters / Query parameters

CAMARA API Design Guide: [5.7.1. Paths](CAMARA-API-Design-Guide.md#571-paths)
> URI with lowercase and hyphens. URIs must be "human-readable" to facilitate identification of the offered resources. Lowercase words and hyphenation (kebab-case) help achieve this best practice. For example: `/customer-segments`

Path parameter should follow a specific case convention, with the default being `kebab` case.

_Spectral rule_: [camara-parameter-casing-convention](/artifacts/linting_rules/.spectral.yml)

*Severity*: `error`

#### Property names

❓ **Should it be lowerCamelCase in DG?**

Property names should follow a specific case convention, with the default being `camel` case.

_Spectral rule_: [camara-property-casing-convention](/artifacts/linting_rules/.spectral.yml)

*Severity*: `error`

#### Schema names

CAMARA API Design Guide: [5.8.1. Schemas](CAMARA-API-Design-Guide.md#581-schemas)

UpperCamelCase should be used for schema names - convention - `pascal`

_Spectral rule_: [camara-schema-casing-convention](/artifacts/linting_rules/.spectral.yml)

*Severity*: `warn`

#### Schema type check

`type` attribute is mandatory in property schema definition.
type - Value MUST be a string in OpenAPI specification.
String values MUST be one of the primitive types defined by the JSON Schema core specification: 
array, boolean, integer, number, object, string

`null` - is not supported in OpenAPI 3.0

_Spectral rule_: [camara-schema-type-check](/artifacts/linting_rules/.spectral.yml)

*Severity*: `error`



## 4. Summary of proposed CAMARA rules

| Name                                                   | Desc                                                                                       | Recommended | CAMARA use | CAMARA severity |
|--------------------------------------------------------|--------------------------------------------------------------------------------------------|-------------|------------|-----------------|
| camara-language-spelling                               | Check spellin in description fields                                                        | No          | No         | Warning         |
| camara-language-avoid-telco                            | Avoid terms/types specific to the telco domain                                             | Yes         | Yes        | Hint            |
| camara-oas-version                                     | Open API version 3.0.3                                                                     | Yes         | Yes        | Error           |
| camara-info−title                                      | API title with public name                                                                 | tbd         | tbd        | Warning         |
| camara-info−version-format                             | API Version in the format: X.Y.Z.                                                          | tbd         | tbd        | Warning         |
| camara-path-param-id                                   | Use 'resource_id' instead of just 'id' for your path parameters                            | Yes         | Yes        | Warning         |
| camara-security-no-secrets-in-path-or-query-parameters | Sensitive data (msisdn/imsi) cannot be a path or query parameter                           | Yes         | Yes        | Warning         |
| camara-http-methods                                    | Valid methods are: GET, PUT, POST, DELETE, PATCH, OPTIONS                                  | Yes         | Yes        | Error           |
| camara-get-no-request-body                             | 'GET' and 'DELETE' http methods MUST NOT accept a 'requestBody' attribute                  | Yes         | Yes        | Error           |
| camara-reserved-words                                  | Reserved words must not be used                                                            | Yes         | Yes        | Warning         |
| camara-resource-reserved-words                         | Resources must not contain the method name                                                 | Yes         | Yes        | Warning         |
| camara-routes-description                              | Functionality methods must have a description.                                             | Yes         | Yes        | Warning         |
| camara-parameters-descriptions                         | All parameters must have a description                                                     | Yes         | Yes        | Warning         |
| camara-response-descriptions                           | All response objects must have a description                                               | Yes         | Yes        | Warning         |
| camara-properties-descriptions                         | All properties within the object must have a description                                   | Yes         | Yes        | Warning         |
| camara-operation-summary                               | Summary must be defined on each operation                                                  | Yes         | Yes        | Warning         |
| camara-discriminator-use                               | discriminator object can be used to aid in serialization, deserialization, and validation  | Yes         | No         | Hint            |
| camara-operationid-casing-convention                   | Operation ids should follow a specific case convention: camel case                         | Yes         | Yes        | Hint            |
| camara-schema-casing-convention                        | Schema should follow a specific case convention pascal case (upper camel case)             | Yes         | Yes        | Warning         |
| camara-parameter-casing-convention                     | Path parameter should follow a specific case convention, with the default being kebab-case | Yes         | Yes        | Error           |
| camara-schema-casing-convention                        | Schema should follow a specific case convention pascal case (upper camel case)             | Yes         | Yes        | Warning         |
| camara-enum-casing-convention                          | enum fields contain values that follow a specific case convention: macro (CAPITAL_LETTERS) | tbd         | tbd        | Info            |
| camara-property-casing-convention                      | Property names should follow a specific case convention, with the default being camel case | Yes         | Yes        | Error           |
| camara-schema-type-check                               | `type` attribute is mandatory in property schema definition                                | Yes         | Yes        | Error           |


