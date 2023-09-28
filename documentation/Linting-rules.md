# CAMARA API Linting Rules Documentation

## Introduction


## 1. Spectral core ruleset

Spectral has a built-in OpenAPI Specification ruleset that can be used to validate OpenAPI files.

With `extends: "spectral:oas"` ("oas" being shorthand for OpenAPI Specification) in the ruleset file to rules for OpenAPI v2 and v3.x, depending on the appropriate OpenAPI version being used (this is automatically detected through formats) are added to the final ruleset.

The full list of the rules in this ruleset are described in [OpenAPI Rules](https://docs.stoplight.io/docs/spectral/4dec24461f3af-open-api-rules).


`extends: [[spectral:oas, off]]`  - this avoids running any rules from the extended ruleset as they are disabled. Each rule can [enabled individually](https://docs.stoplight.io/docs/spectral/0a73453054745-recommended-or-all#enabling-rules).

### OpenAPI v2 & v3
Rules applying to both OpenAPI v2.0, v3.0, and most likely v3.1.


|Name| Desc| Recommended|CAMARA use|
|---|---|---|--|
|contact-properties| contact object is full of the most useful properties: `name`, `url`, `and email`|No|No |
|duplicated-entry-in-enum| Each value of an `enum` must be different from one another |Yes  | Yes |
|info-contact |Info object should contain `contact` object |Yes  | Yes| 








## 2. Language

### Spell checking

CAMARA API specification files include inline documentation.

The description attributes should be checked for typos.

_Spectral rule_: [camara-language-spelling]()


### Reduce telco-specific terminology in API definitions

API Design Guidelines: [2.5 Reduce telco-specific terminology in API definitions](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-design-guidelines.md#25-reduce-telco-specific-terminology-in-api-definitions)

Consider and account for how the API can be fulfilled on a range of network types.
Avoid terms/types specific to a given telco domain -  terms should be inclusive beyond mobile network. 

See also [CAMARA Glossary](https://github.com/camaraproject/Commonalities/blob/main/documentation/Glossary.md)


| ❌ &nbsp; Not recommended | 👍  &nbsp; Recommended |
|----------------------------|-------------------------|
| `UE`                 | `device`           |
| `MSISDN`                 | `phone number`           |
| `mobile network`      | `network`         |


_Spectral rule_: [camara-language-avoid-telco]()

