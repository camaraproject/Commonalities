# Changelog Commonalities

## Table of Contents

- [v0.4.0-rc.1](v040-rc1)
- [v0.4.0-alpha.1](#v040-alpha1)
- [v0.3.0](#v030)
- [v0.2.0](#v020)
- [v0.1.0 - Initial version](#v010---initial-version)


# v0.4.0-rc.1

**This version introduces Event Subscription model based on [CloudEvents Subscriptions API draft](https://github.com/cloudevents/spec/blob/main/subscriptions/spec.md) and other changes to documents and artifacts approved since [v0.3.0](#v030).**

**The relevant details of authentication and consent collection are covered by [version 0.2.0](https://github.com/camaraproject/IdentityAndConsentManagement/releases) of Identity and Consent Working Group documents.**

## Please note:
This is the first **Release Candidate** version for Commonalities release 0.4.0. 

The content of the release includes:
* Commonalities approved deliverables in **[documentation](https://github.com/camaraproject/Commonalities/tree/r0.4.0-rc.1/documentation)** folder
  - **Removed or deprecated:**
    - API-Readiness-Checklist.md
    - Camara_Versioning_Guidelines.md
    - CHANGELOG_TEMPLATE.md
* Commonalities approved artifacts in **[artifacts](https://github.com/camaraproject/Commonalities/tree/r0.4.0-rc.1/artifacts)** folder
  - **New:**
    - [Notification Subscription Template](https://github.com/camaraproject/Commonalities/blob/r0.4.0-rc.1/artifacts/camara-cloudevents/event-subscription-template.yaml)


### Added
* Usage and style of operation tags in API Design Guidelines by @rartych in https://github.com/camaraproject/Commonalities/pull/152
* x-correlator support in notifications in API Design Guidelines by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/170
* Create subscription-notification-template.yaml by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/189
* Added a different scope naming format for APIs that deal with explicit subscriptions by @shilpa-padgaonkar in https://github.com/camaraproject/Commonalities/pull/177
* 'info' object, 'servers' added in chapter 11 of API Design Guidelines:  by @rartych in https://github.com/camaraproject/Commonalities/pull/214
* Guidelines on device identification in Annex A of API Design Guidelines and device object usage in CAMARA_common.yaml by @jpengar in https://github.com/camaraproject/Commonalities/pull/233
* `minItems: 1` & `maxItems: 1` for subscription `types` in event-subscription-template.yaml by @maxl2287 in https://github.com/camaraproject/Commonalities/pull/236
* `SUBSCRIPTION_DELETED` as new `terminationReason` for CloudEvents by @maxl2287 in https://github.com/camaraproject/Commonalities/pull/238


### Changed
* API Design Guidelines updated with subscriptionMaxEvents by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/131
* 'specversion' in CloudEvents as enum by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/187
* 'datacontenttype' in CloudEvents as enum by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/193
* API Design Guidelines updated on x-correlator format by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/194
* API Design Guidelines for Notification Subscription by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/198
* API Design Guidelines updated on scope definition including wildcard scopes by @shilpa-padgaonkar in https://github.com/camaraproject/Commonalities/pull/221
* API Design Guidelines adapted to ICM Security and Interoperability Profile by @AxelNennker in https://github.com/camaraproject/Commonalities/pull/208
* Error response model updated in chapter 6 of API Design Guidelines by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/213
* Enhanced API-Testing-Guidelines.md by @jlurien in https://github.com/camaraproject/Commonalities/pull/203
* Updated API versioning guidelines chapter 5 of API Design Guidelines by @tanjadegroot in https://github.com/camaraproject/Commonalities/pull/215
  

### Fixed
* API Design Guidelines updated with character set guidance by @trehman-gsma in https://github.com/camaraproject/Commonalities/pull/143
* Mandated '+' in all phoneNumber formats by @fernandopradocabrillo in https://github.com/camaraproject/Commonalities/pull/148
* Linting rules problem with Traffic Influence API #161 by @VijayKesharwani in https://github.com/camaraproject/Commonalities/pull/169
* CAMARA_common.yaml - bugs and typos fix by @fernandopradocabrillo in https://github.com/camaraproject/Commonalities/pull/174
* API Design Guidelines updated on HTTPs usage by @AxelNennker in https://github.com/camaraproject/Commonalities/pull/205
* Artifacts aligned with API Design Guidelines for Notification Subscription by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/219

### Removed
* Removed UUID pattern for x-correlator by @jlurien in https://github.com/camaraproject/Commonalities/pull/168
* Deprecated API-Readiness-Checklist.md by @rartych in https://github.com/camaraproject/Commonalities/pull/220
* Removed Camara_Versioning_Guidelines.md by @tanjadegroot in https://github.com/camaraproject/Commonalities/pull/215

**Full Changelog**: https://github.com/camaraproject/Commonalities/compare/v0.3.0...r0.4.0-rc.1


# v0.4.0-alpha.1

**This version introduces Event Subscription model based on [CloudEvents Subscriptions API draft](https://github.com/cloudevents/spec/blob/main/subscriptions/spec.md) and other changes to documents and artifacts approved since v0.3.0.**

## Please note:
This is **ALPHA** version for Commonalities release 0.4.0. The following changes are expected to be added in the **Release Candidate**:
* Error model alignment [PR#213](https://github.com/camaraproject/Commonalities/pull/213)
* Enhance API-Testing-Guidelines.md [PR#203](https://github.com/camaraproject/Commonalities/pull/203)
* API Design Guidelines chapter 11: 'info' object, 'servers' object and cleanup  [PR#214](https://github.com/camaraproject/Commonalities/pull/214)
* Alignment with ICM and Release Management

The content of the release includes:
* Commonalities approved deliverables in **[documentation](https://github.com/camaraproject/Commonalities/tree/r0.4.0-alpha.1/documentation)** folder
* Commonalities approved artifacts in **[artifacts](https://github.com/camaraproject/Commonalities/tree/r0.4.0-alpha.1/artifacts)** folder
  - **New:**
    - [Notification Subscription Template](https://github.com/camaraproject/Commonalities/blob/r0.4.0-alpha.1/artifacts/camara-cloudevents/event-subscription-template.yaml)

### Added
* Usage and style of operation tags in API Design Guidelines by @rartych in https://github.com/camaraproject/Commonalities/pull/152
* x-correlator support in notifications in API Design Guidelines by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/170
* Create subscription-notification-template.yaml by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/189
* Added a different scope naming format for APIs that deal with explicit subscriptions by @shilpa-padgaonkar in https://github.com/camaraproject/Commonalities/pull/177 
### Changed
* API Design Guidelines updated with subscriptionMaxEvents by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/131
* 'specversion' in CloudEvents as enum by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/187
* 'datacontenttype' in CloudEvents as enum by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/193
* API Design Guidelines updated on x-correlator format by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/194
* API Design Guidelines for Notification Subscription by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/198
* API Design Guidelines updated on scope definition including wildcard scopes by @shilpa-padgaonkar in https://github.com/camaraproject/Commonalities/pull/221

### Fixed
* API Design Guidelines updated with character set guidance by @trehman-gsma in https://github.com/camaraproject/Commonalities/pull/143
* Mandated '+' in all phoneNumber formats by @fernandopradocabrillo in https://github.com/camaraproject/Commonalities/pull/148
* Linting rules problem with Traffic Influence API #161 by @VijayKesharwani in https://github.com/camaraproject/Commonalities/pull/169
* CAMARA_common.yaml - bugs and typos fix by @fernandopradocabrillo in https://github.com/camaraproject/Commonalities/pull/174
* API Design Guidelines updated on HTTPs usage by @AxelNennker in https://github.com/camaraproject/Commonalities/pull/205
* Artifacts aligned with API Design Guidelines for Notification Subscription by @PedroDiez in https://github.com/camaraproject/Commonalities/pull/219

### Removed
* Removed UUID pattern for x-correlator by @jlurien in https://github.com/camaraproject/Commonalities/pull/168


**Full Changelog**: https://github.com/camaraproject/Commonalities/compare/v0.3.0...r0.4.0-alpha.1

# v0.3.0

**This version introduces API Testing Guidelines and initial linting ruleset and other changes to documents and artifacts approved since v0.2.0.**

## Please note:
The content of the release includes:
* Commonalities approved deliverables in **[documentation](https://github.com/camaraproject/Commonalities/tree/release-0.3.0/documentation)** folder
  - **New:**
    - [API Testing Guidelines](https://github.com/camaraproject/Commonalities/blob/release-0.3.0/documentation/API-Testing-Guidelines.md)
    - [API Linting Rules](https://github.com/camaraproject/Commonalities/blob/release-0.3.0/documentation/Linting-rules.md)
    - [OpenAPI Linting Rules Implementaion Guideline](https://github.com/camaraproject/Commonalities/blob/release-0.3.0/documentation/API-linting-Implementation-Guideline.md)
* Commonalities approved artifacts in **[artifacts](https://github.com/camaraproject/Commonalities/tree/release-0.3.0/artifacts)** folder
  - **New:**
    -  [CAMARA_common.yaml](https://github.com/camaraproject/Commonalities/blob/release-0.3.0/artifacts/CAMARA_common.yaml)
    -  [Linting rules implementation files](https://github.com/camaraproject/Commonalities/tree/release-0.3.0/artifacts/linting_rules)

### Added
* API Testing Guidelines created by @shilpa-padgaonkar in https://github.com/camaraproject/Commonalities/pull/117
* API Design Guidelines updated with scopes naming guidelines by @jlurien in https://github.com/camaraproject/Commonalities/pull/57
* API Linting Rules - initial linting ruleset description by @rartych in https://github.com/camaraproject/Commonalities/pull/74
* API linting implementation and guidelines by @ravindrapalaskar17 in https://github.com/camaraproject/Commonalities/pull/110
  
### Changed
* CAMARA_common.yaml includes the following changes:
  - CAMARA_common.json was changed to CAMARA_common.yaml to be consistent with all CAMARA API specs
  - Includes guidance for info object
  - Adds the aligned device schema updated by @shilpa-padgaonkar in https://github.com/camaraproject/Commonalities/pull/107

* X-Correlator header as required in OAS definition, X-Version removed from API Design Guidelines by @jlurien in https://github.com/camaraproject/Commonalities/pull/115
* Filtering criteria in API Design Guidelines changed by @RubenBG7 in https://github.com/camaraproject/Commonalities/pull/132

### Fixed
* CAMARA_common.yaml - error response codes updated by @RubenBG7 in https://github.com/camaraproject/Commonalities/pull/124
* API Design Guidelines updated on response filtering by @rartych in https://github.com/camaraproject/Commonalities/pull/123

### Removed
* API-exposure-reference-solution.docx removed from documentation/SupportingDocuments by @jordonezlucena in https://github.com/camaraproject/Commonalities/pull/104

**Full Changelog**: https://github.com/camaraproject/Commonalities/compare/v0.2.0...v0.3.0


# v0.2.0

**This version introduces CloudEvents format to CAMARA Events and other changes to documents and artifacts approved since v0.1.0.**

## Please note:
The content of the release includes:
* Commonalities approved deliverables in **[documentation](https://github.com/camaraproject/Commonalities/tree/release-0.2.0/documentation)** folder
* Commonalities approved artifacts in **[artifacts](https://github.com/camaraproject/Commonalities/tree/release-0.2.0/artifacts)** folder
  - **New:** OAS definition of CAMARA Event using CloudEvents: **[notification-as-cloud-event.yaml](https://github.com/camaraproject/Commonalities/blob/release-0.2.0/artifacts/notification-as-cloud-event.yaml)**


### Added
* Added reserved word restrictions to API Design Guidelines by @eric-murray in https://github.com/camaraproject/Commonalities/pull/49
* Explicitly indicated use of RFC3339 for DateTime attributes by @patrice-conil in https://github.com/camaraproject/Commonalities/pull/55
* Usage of discriminator: Encourage inheritance rather than polymorphism by @patrice-conil in https://github.com/camaraproject/Commonalities/pull/22
* Use ObjectName as discriminator's mapping key by @patrice-conil in https://github.com/camaraproject/Commonalities/pull/78
* OAS definition of CAMARA Event using Cloudevents in artifacts: [notification-as-cloud-event.yaml](https://github.com/camaraproject/Commonalities/blob/release-0.2.0/artifacts/notification-as-cloud-event.yaml) by @patrice-conil in https://github.com/camaraproject/Commonalities/pull/43
    
### Changed
* Updated API Design Guidelines with use of callbacks & cloudEvents by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/56
* Updated Architecture headers in API Design Guidelines by @eric-murray in https://github.com/camaraproject/Commonalities/pull/88

### Fixed
* Fixed code typos in API Design Guidelines section 11.5.1 code sample by @Kevsy in https://github.com/camaraproject/Commonalities/pull/48
* Correction of format and typos by @dfischer-tech in https://github.com/camaraproject/Commonalities/pull/79
* Improved discovery of Commonalities output documents by API Subprojects by @rkandoi in https://github.com/camaraproject/Commonalities/pull/73
* Updated references in UE-Identification.md by @gmuratk in https://github.com/camaraproject/Commonalities/pull/95
* Minor changes needed in API Design Guidelines for CloudEvents by @rartych in https://github.com/camaraproject/Commonalities/pull/86
* Filtering GET results - updated section 8.3 in API Design Guidelines by @rartych in https://github.com/camaraproject/Commonalities/pull/82

### Removed
* Removed option to use HTTP HEAD from API-design-guidelines.md by @eric-murray in https://github.com/camaraproject/Commonalities/pull/50

**Full Changelog**: https://github.com/camaraproject/Commonalities/compare/v0.1.0...v.0.2.0


# v0.1.0 - Initial version

**Initial version of guidelines and assets based on the work done in [Commonalities WG](https://github.com/camaraproject/WorkingGroups/tree/main/Commonalities).**

## Please note:
The content of the release includes:
* Commonalities approved deliverables in **documentation** folder:
   - **[API-Readiness-Checklist.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/API-Readiness-Checklist.md)** - A checklist to ensure minimum readiness of the API
   - **[API-design-guidelines.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/API-design-guidelines.md)** - API design guidelines -the main document with guidelines for the API design in CAMARA project. These guidelines are applicable to every CAMARA API;
   - **[Camara_Versioning_Guidelines.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/Camara_Versioning_Guidelines.md)** - Guidelines to create CAMARA subproject releases
   - **[Glossary.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/Glossary.md)** - Glossary of terms and common parameter/field names to be used in every CAMARA API
   - **[Issue and PR template Howto.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/Issue%20and%20PR%20template%20Howto.md)** - Instruction for use of Github templates for issues and pull request for CAMARA repositories
   - **[UE-Identification.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/UE-Identification.md)** - an overview of methods that a 5G Core network has for enabling external parties to identify UEs in the network
   - **[Userstory-template.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/Userstory-template.md)** - the template for documenting user stories related to API families in CAMARA project
   - **[API-DocumentationTemplate.md](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/documentation/API-DocumentationTemplate.md)**- API documentation template - currently obsoleted by embedding documentation into OAS YAML files
* Commonalities approved artifacts in **artifacts** folder:
   - **[CAMARA_common.json](https://github.com/camaraproject/Commonalities/blob/release-0.1.0/artifacts/CAMARA_common.json)** - Common data and errors for CAMARA APIs in JSON file
   - **[Github_templates](https://github.com/camaraproject/Commonalities/tree/release-0.1.0/artifacts/Github_templates/.github)** - `.github` folder with Github templates for issues and pull request
