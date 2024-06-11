# API Testing Guidelines

## Table of Contents
1. [Introduction](#introduction)
2. [Test Cases contributions for APIs](#test-cases-contribution-for-apis)
3. [Location of feature file](#location-of-feature-file)
4. [Best practices and recommendations](#best-practices-and-recommendations)
5. [References](#references)

## Introduction
This document captures guidelines for the API testing in CAMARA project. These guidelines are applicable to every API to be worked out under the CAMARA initiative.

## Test Cases contribution for APIs
Based on the decision taken in the Commonalities working group and as documented in [API-Readiness-Checklist](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Readiness-Checklist.md).
At least one Gherkin feature file will be added to the main subproject repo, and this will fulfill the minimum criteria of readiness with respect to API test cases and documentation. 
If subprojects also intend to add test implementations, an aligned single implementation agreed among all provider implementors could be added to the main subproject repo. 
If no alignment is possible, each provider implementer will add the test implementation to their own repos.

Based on the decision made in the Commonalities working group and as documented in the [API-Readiness-Checklist](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Readiness-Checklist.md), at least one Gherkin feature file will be included in the main subproject repository. 
This action will meet the minimum readiness criteria for API test cases and documentation. 
If subprojects also plan to include test implementations, a unified implementation agreed upon by all provider implementors could be added to the main subproject repository. 
If alignment is not possible, each provider implementer will add the test implementation to their respective repositories.

## Location of feature file
The feature file will reside under 
```
Subproject_Repository/code/Test_definitions/file_name.feature
for e.g. https://github.com/camaraproject/QualityOnDemand/blob/main/code/Test_definitions/QoD_API_Test.feature
```

## Best practices and recommendations

* Granularity of the feature file must be decided at the project level, but it is recommended to:
    -	group in one file all scenarios testing one closely related API capability (that can cover one or several endpoints).
    -	provide several files when one CAMARA API (yaml) covers several independent functions that can be provided independently

* Third-Person pronoun usage in feature file is advisable as using the third person, conveys information in a more official manner.
* It is recommended to only have one When/Then in a feature file as per cucumber official documentation's recommendations. However, in the case of complex scenarios, several when/then can be allowed.
* The recommended format for scenario identifier is shown below
    ```
    '@'<(mandatory)name of the resource>_<(mandatory)number XX>_<(optional)short detail in lower case and using underscore “_” as the separator>)
      for e.g. (@check_simswap_01_verify_swap_true_default_maxage).
    ```

* Recommendation is to have API literal request value (for example), but in case of exceptions, it is fine to use ready payload as well.


## References

* [Feature files]( https://copyprogramming.com/howto/multiple-feature-inside-single-feature-file#multiple-feature-inside-single-feature-file)
* [Scenario Identifier](https://support.smartbear.com/cucumberstudio/docs/tests/best-practices.html#scenario-content-set-up-writing-standards)
* [One when/then](https://cucumber.io/docs/gherkin/reference/)
