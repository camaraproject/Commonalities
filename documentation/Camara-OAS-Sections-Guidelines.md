# CAMARA OAS Sections Guidelines 

## Table of Contents

   * [Introduction](#introduction)
   * [Conventions](#conventions)
   * [OAS Sections](#oas-sections)
     + [OpenAPI Version](#version)
     + [Info Object](#info-object)
       + [Title](#title)
       + [Description](#description)
       + [Version](#version)
       + [Terms of service](#tos)
       + [Contact information](#contact)
       + [License](#license)
       + [Extension field](#ext-field)
     + [Servers](#servers)
     + [Paths](#paths)
     + [Components](#components)
       + [Schemas ](#schemes)
       + [Responses](#responses)
       + [Parameters](#parameters)
       + [Request bodies](#req-bodies)
       + [Headers](#headers)
       + [Security schemes](#sec-schemes)
     + [Security](#security)
     + [Tags](#tags)
     + [External Documentation](#ext-doc)

## Introduction
Camara uses OpenAPI Specification (OAS) to describe its APIs. The below guidelines specify the restrictions or conventions to be followed within the OAS yaml by all Camara APIs (referred below simply as APIs).

## Conventions
The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

## OAS Sections

### OpenAPI Version
APIs shall use the OAS version 3.0.3.

### Info Object
An example of the info object is shown below:
```
info:
  title: Number Verification
  description: |
    This API allows to verify that the provided mobile phone number is the one used in the device. It
    verifies that the user is using a device with the same mobile phone number as it is declared.
  version: 1.0.1
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html
  x-camara-commonalities: 0.4.0
  
```
#### Title
API name shall be specified in the title but this shall not include the term "API" in it.

#### Description
Description should shortly describe the API.

#### Version
APIs shall use the [versioning-format](https://lf-camaraproject.atlassian.net/wiki/x/3yLe) as specified by the release management working group.

#### Terms of service
Terms of service shall not be included. API providers may add this content when documenting their APIs.

#### Contact information
Contact information shall not be includeds. API providers may add this content when documenting their APIs.

#### License
The license object shall include the following fields:
```
license
  name: Apache 2.0
  url: https://www.apache.org/licenses/LICENSE-2.0.html
```

#### Extension field
The API shall specify the commonalities release number they are compliant to, by including the x-camara-commonalities extension field.

### Servers
The servers object shall have the following content:
```
servers:
  - url: {apiRoot}/<api-name>/<api-version>
    variables:
      apiRoot:
        default: http://localhost:9091
        description: API root, defined by the service provider, e.g. `api.example.com` or `api.example.com/somepath`
```
API-name and API-Version shall be same as the [Title](#title) and [Version](#version) in the Info Object respectively.
