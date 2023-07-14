# API Readiness minimum criteria checklist
| No | Deliverables/Criteria      | Mandatory | Reference template                          |
|----|--------------     |-----------|--------------------                         |
|  1 |API Spec          | Y         | OAS3  (https://spec.openapis.org/oas/v3.0.3)|
|  2 |API Implementation |   N        |                                             |
| 3   |API Documentation  |   Y        |The API specification should include all the needed documentation.                                           |
|4   |User Stories  |   Y        |	https://github.com/camaraproject/Commonalities/blob/main/documentation/Userstory-template.md                                            |
| 5   |API test cases and documentation  |   Y        | A Gherkin feature file will be added to the main subproject repo and this will fulfill the minimum criteria of readiness w.r.t API test cases and documentation. If subprojects also intend to add test implementations, an aligned single implementation that is agreed amongst all provider implementors could be added to the main subproject repo. If no alignment is possible, each provider implementor will add the test implementation to their own repos   |
| 6   |Tested by atleast 2 operators  |   Y        |                                             |
| 7   |Security review  |   Y        |  Spec contributions should include a security scheme section that complies with the AuthN&AuthZ techniques agreed in Commonalities.                                   |

