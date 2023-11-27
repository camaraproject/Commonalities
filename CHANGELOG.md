# Changelog Commonalities

## Table of Contents

- [v0.2.0](#v020)
- [v0.1.0 - Initial version](#v010---initial-version)

# v0.2.0
The content of the release includes:
* Commonalities approved deliverables in **documentation** folder
* Commonalities approved artifacts in **artifacts** folder


### Added
* Added reserved word restrictions to API-design-guidelines.md by @eric-murray in https://github.com/camaraproject/Commonalities/pull/49
* Explicitly indicated use of RFC3339 for DateTime attributes by @patrice-conil in https://github.com/camaraproject/Commonalities/pull/55
* Usage of discriminator: Encourage inheritance rather than polymorphism by @patrice-conil in https://github.com/camaraproject/Commonalities/pull/22
* Use ObjectName as discriminator's mapping key by @patrice-conil in https://github.com/camaraproject/Commonalities/pull/78
    
### Changed
* Updated DG with use of callbacks & cloudEvents by @bigludo7 in https://github.com/camaraproject/Commonalities/pull/56

### Fixed
* Fixed code typos in Design Guidelines section 11.5.1 code sample by @Kevsy in https://github.com/camaraproject/Commonalities/pull/48
* Correction of format and typos by @dfischer-tech in https://github.com/camaraproject/Commonalities/pull/79
* Improved discovery of Commonalties output documents by API Subprojects by @rkandoi in https://github.com/camaraproject/Commonalities/pull/73


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
