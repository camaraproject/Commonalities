<a href="https://github.com/camaraproject/Commonalities/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/Commonalities?style=plastic"></a>
<a href="https://github.com/camaraproject/Commonalities/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/Commonalities?style=plastic"></a>
<a href="https://github.com/camaraproject/Commonalities/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/Commonalities?style=plastic"></a>
<a href="https://github.com/camaraproject/Commonalities/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/Commonalities?style=plastic"></a>
<a href="https://github.com/camaraproject/Commonalities" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/Commonalities?style=plastic"></a>
<a href="https://github.com/camaraproject/Commonalities/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<img src="https://img.shields.io/badge/Working%20Group-red">

# Commonalities
Repository to describe and document common guidelines and assets for CAMARA APIs

## Scope
* Guidelines and assets for “Commonalities” (see APIBacklog.md)  
* All deliverables are mandatory for all CAMARA Sub Projects 
* Describe, develop, document and test the deliverables
* Started: October 2021

## Documents for CAMARA Sub Projects

The documents that are relevant for CAMARA API Sub Projects are found in the `documentation` directory (at the top-level). The rest of the sub-directories are primarily for internal working of the Commonalities Working Group.

The `artifacts` directory contains:
* templates for creating Github issues
* common data and error formats for CAMARA APIs in [CAMARA_common.yaml](artifacts/CAMARA_common.yaml)
* notification subscription template: [event-subscription-template.yaml](artifacts/camara-cloudevents/event-subscription-template.yaml)
* OAS definition of CAMARA Event using CloudEvents: [notification-as-cloud-event.yaml](artifacts/notification-as-cloud-event.yaml)
* Common artifacts for testing error scenarios for device and phoneNumber: in [artifacts/testing](artifacts/testing) folder 

### Frequently-accessed output documents

A list of some of the frequently accessed documents that are an output of the work done in the Commonalities Working Group is provided below. Note that the links are relative to the branch selected. Refer to the section below for released versions. 

| Document name                                                                                                                             | Purpose                                                                                                                                                            |
|-------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
 | [CAMARA API Design Guide](/documentation/CAMARA-API-Design-Guide.md)               | This document captures guidelines for the API design in CAMARA project. These guidelines are applicable to every API to be worked out under the CAMARA initiative. | 
 | [CAMARA API Event Subscription and Notification Guide](/documentation/CAMARA-API-Event-Subscription-and-Notification-Guide.md) | This document outlines guidelines applicable to all APIs that provide capabilities for event subscription and notification management. |
| [Glossary.md](documentation/Glossary.md)                                         | A glossary of the common terms and their API parameter/field names for use in the APIs                                                                             |
| [API-Testing-Guidelines.md](documentation/API-Testing-Guidelines.md)             | Guidelines for the API testing in CAMARA project                                                                                                   |
| [API-cheatsheet.md](documentation/API-cheatsheet.md)                             | CAMARA syntax cheatsheet    |

NOTE: Guidelines for Release Management of API versions, e.g. the API-Readiness-Checklist, are located within [ReleaseManagement](https://github.com/camaraproject/ReleaseManagement). The versioning of APIs is defined within the [CAMARA API Design Guide](/documentation/CAMARA-API-Design-Guide.md#7-versioning). 


## Status and released versions
* Release 0.6.0 of guidelines and assets for Fall 25 CAMARA APIs is available with the [r3.3 tag](https://github.com/camaraproject/Commonalities/tree/r3.3)
* Previous releases and pre-releases are available in https://github.com/camaraproject/Commonalities/releases

For changes see [CHANGELOG.md]([CHANGELOG.md](https://github.com/camaraproject/Commonalities/blob/main/CHANGELOG.md).

## Meetings
* Meetings are held virtually on the LF Platform: [Meeting Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/91016460698?password=d031b0e3-8d49-49ae-958f-af3213b1e547)
* Schedule: bi-weekly, Monday, 15:00 UTC  (4 PM CET / 5 PM CEST). The date of the next meeting can be found in the previous [meeting minutes](https://lf-camaraproject.atlassian.net/wiki/x/2AD7Aw).


## Contributorship and mailing list
* To subscribe / unsubscribe to the mailing list of this Sub Project and thus be / resign as Contributor please visit <https://lists.camaraproject.org/g/wg-commonalities>.
* A message to all Contributors of this Sub Project can be sent using <wg-commonalities@lists.camaraproject.org>.
