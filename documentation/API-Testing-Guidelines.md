# API Testing Guidelines

## Table of Contents
1. [Introduction](#introduction)
2. [Test Cases contributions for APIs](#contribution)
3. [Location of feature file](#location)
4. [Best practices and recommendations](#recommendations)
7. [References](#references)

## Introduction <a name="introduction"></a>
This document captures guidelines for the API testing in CAMARA project. These guidelines are applicable to every API to be worked out under the CAMARA initiative.

## Test Cases contribution for APIs <a name="contribution"></a>
Based on the decision taken in the commonalities working group and as documented in [API-Readiness-Checklist](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Readiness-Checklist.md), a Gherkin feature file will be added to the main subproject repo and this will fullfil the minimum criteria of readiness w.r.t API test cases and documentation. If subprojects also intend to add test implementations, an aligned single implementation that is agreed amongst all provider implementers could be added to the main subproject repo. If no alignment is possible, each provider implementer will add the test implementation to their own repos.

## Location of feature file <a name="location"></a>
The feature file will reside under 
```
Subproject_Repository/code/Test_definitions/file_name.feature
for e.g. https://github.com/camaraproject/QualityOnDemand/blob/main/code/Test_definitions/QoD_API_Test.feature
```

## Best practices and recommendations <a name="recommendations"></a>

* One feature file per API is advisable so that all scenarios can be covered corresponding to the API & the corresponding resource.
* Third Person pronoun usage in feature file is advisable as using the third person, conveys information in a more official manner.
* It is recommended to only have one When/Then in a feature file as per cucumber official documentation's recommendations. However, in case of  complex scenarios, several when/then can be allowed.
* The recommended format for scenario identifier is shown below
    ```
    '@'<(mandatory)name of the resource>_<(mandatory)number XX>_<(optional)short detail in lower case and using underscore “_” as the separator>)
      for e.g. (@check_simswap_01_verify_swap_true_default_maxage).
    ```

* Recommendation is to have API literal request value (with example) but in case of exceptions, it is fine to use ready payload as well.


## References <a name="references"></a>

* [One feature file per API](https://www.testquality.com/blog/tpost/v79acjttj1-cucumber-and-gherkin-language-best-pract)
* [Scenario Identifier](https://support.smartbear.com/cucumberstudio/docs/tests/best-practices.html#scenario-content-set-up-writing-standards)
* [One when/then](https://cucumber.io/docs/gherkin/reference/)
