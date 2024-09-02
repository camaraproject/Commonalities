# CAMARA OpenAPI and Gherkin Linting Rules Implementaion Guideline [ How to integrate the rules into CAMARA repository ]

## Introduction

This guide provides instructions how to implement linting rules for the CAMARA APIs  using two methods: **[GitHub Actions](API-linting-Implementation-Guideline.md#github-actions-integration)** and **[local deployment](API-linting-Implementation-Guideline.md#github-actions-integration)**, both methods use [Spectral tool](https://docs.stoplight.io/docs/spectral/674b27b261c3c-overview).
All needed files are stored in [artifacts subfolder](https://github.com/camaraproject/Commonalities/tree/API-linting-Implementation-Guideline/artifacts/linting_rules).

Additionally, it provides an overview of how to integrate Gherkin linting to test the feature files of test contributions.

The target method is linting rules integration with CAMARA API subproject repositories using GitHub Actions.


## Spectral Configuration

The Spectral configuration consists of <b><a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.spectral.yml"> .spectral.yml</a></b> file, which contains all the rules defined for CAMARA OpenAPI specification as described in [Linting-rules.md](Linting-rules.md)

This file consolidates all rules:

1.  Spectral Core OpenAPI specification linting ruleset:

    `Ruleset extension: extends: "spectral:oas"`

2.  Spectral rules with built-in functions
3.  Spectral rules with custom<a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function"> JavaScript functions</a>

## Gherkin Linting  Configuration

The Gherkin Linting configuration consists of <b><a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.gherkin-lintrc"> .gherkin-lintrc</a></b> file, which contains all the rules defined for API Testing Guideline  as described in [API-Testing-Guidelines.md](API-Testing-Guidelines.md)


## GitHub Actions Integration (Spectral)

1. Add **[.spectral.yml](https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.spectral.yml)** (rules) file to -> root location of repository

2. Create **lint-function** folder

   Make a folder named `lint_function` at root location and add custom [JavaScript function files](https://github.com/camaraproject/Commonalities/tree/API-linting-Implementation-Guideline/artifacts/linting_rules/lint_function) that are imported in .spectral.yml (some rules require custom JavaScript functions to execute).

3. Add **[spectral_oas_lint.yml](https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.github/workflows/spectral_oas_lint.yml)** to GitHub action workflows in `.github/workflows` folder
   which includes the configuration of Spectral workflow for GitHub actions.

4. Add <b>[megalinter.yml](https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.github/workflows/megalinter.yml)</b> to GitHub action workflows  in  `.github/workflows` folder
   which includes the configuration of Megalinter and Spectral for GitHub actions.

## GitHub Actions Integration (Gherkin)

1. Add **[.gherkin-lintrc](https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.gherkin-lintrc)** (rules) file to -> root location of repository

2. Add <b>[megalinter.yml](https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.github/workflows/megalinter.yml)</b> to GitHub action workflows  in  `.github/workflows` folder
   which includes the configuration of Megalinter and Spectral for GitHub actions.   

### Manually running linting workflow

**spectral_oas_lint.yml** includes configuration of the OAS linting workflow to be run manually as described in [GitHub Actions documentation](https://docs.github.com/en/actions/using-workflows/manually-running-a-workflow).

The rules will be applied to all files with *.yaml extension in '/code/API_definitions/' folder of the repository.
Write access to the repository is required to perform these steps.

The output from Spectral can be seen by expanding the step **Run Spectral Linting** of given worflow run Actions section of GitHub repository.


### Megalinter integration

[Megalinter](https://megalinter.io/latest/) is an Open-Source tool for CI/CD workflows that analyzes the consistency of code, configurations and scripts in repository sources. Megalinter supports Spectral linting.
The Megalinter job will be automatically activated once you submit a pull request on the [main/master] branch of the CAMARA repository, as configured in megalinter.yml.

The Megalinter configuration consists of the <b><a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function/workflows/megalinter.yml">megalinter.yml </a></b> file containing the necessary settings to run Megalinter and Spectral jobs on GitHub actions.

Additionally, Megalinter also supports linting of YAML files. To enable this, users need to add the following ruleset files to the root location.

-  <b>YAML Linting:</b> <a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function/workflows.yamllint.yaml"> .yamllint.yaml </a>




## API Linting configuration steps for local deployment

1.  Install Spectral locally:

        npm install -g @stoplight/spectral

2.  Install Spectral functions locally:

        npm install --save @stoplight/spectral-functions

3.  Save files locally:

    Save ".spectral.yml" file (contains Linting rules) and lint_function folder (contains JavaScript customized functions) at the root location.

4.  Apply spectral rules on API specification loacally:

        spectral lint openapi.yaml --verbose --ruleset .spectral.yml

    *Replace **'openapi.yaml'** with the path to your OpenAPI specification file.*

## Gherkin Integration for Test Contribution Feature Files for local deployment

To integrate Gherkin linting into the Megalinter setup, follow these steps:

1. Install Gherkin Linter locally:

        npm install -g gherkin-lint

2. Save files locally:

   Save  .gherkin-lintrc file at the root location of your repository with the desired linting rules.

3. Apply Gherkin rules on Test defination feature file loacally:

        gherkin-lint Test.feature

    *Replace **'test.feature'** with the path to your Test defination feature file.*
   

