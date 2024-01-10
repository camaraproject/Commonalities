# CAMARA OpenAPI Linting Rules Implementaion Guideline [ How to integrate the rules into CAMARA repository ]

## Introduction

This guide provides instructions to implement linting rules for the CAMARA APIs using two methods: <b>Spectral Linting</b> and <b>Megalinter with Spectral Linting.</B>

CAMARA recommends the second method, incorporating Megalinter with Spectral.

## Megalinter with Spectral Linting

Megalinter is an open-source tool for CI/CD workflows that analyzes the consistency of code, IAC, configuration, and scripts in repository sources. Megalinter supports Spectral Linting.

## Implementation Files

<b><a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function/workflows/megalinter.yml">megalinter.yml </a></b>:- Contains the configuration of megalinter along with spectral.

<b><a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.spectral.yml"> .spectral.yml </a></b> :- Linting rules based on the<a href="https://github.com/camaraproject/Commonalities/blob/main/documentation/Linting-rules.md"> OpenAPI Specification</a>

## GitHub Actions Integration

1. Add <b>megalinter.yml</b> to GitHub action workflow --> .github/workflows

   which include the configuration of megalinter and spectral for GitHub actions.

2. Add<b> .spectral.yml</b> (rules) file to -> root location of repository

3. Create lint-function folder

   Make a folder named lint_function at root location and add custom javascript function files that are imported in .spectral.yml (some rules require custom JavaScript functions to execute).

4. Activate megalinter job

   The megalinter job will be automatically activated once you submit a pull request on the [main/master] branch of the CAMARA repository, as configured in megalinter.

## Megalinter configuration:

The megalinter configuration consists of the <b><a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function/workflows/megalinter.yml">megalinter.yml </a></b> file containing the necessary settings to run megalinter and spectral jobs on GitHub actions.

Additionally, megalinter also supports linting of YAML and Java files. To enable this, users need to add the following ruleset files to the root location.

1.  <b>Java Linting:</b> <a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function/workflows/javalint.xml"> javalint.xml</a>

2.  <b>YAML Linting:</b> <a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function/workflows.yamllint.yaml"> .yamllint.yaml </a>

## Spectral Configuration

The spectral configuration consists of <b><a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/.spectral.yml"> .spectral.yml</a></b> file, which contains all the rules defined in the CAMARA OpenAPI specification.

This file consolidates all rules:

1.  Spectral built-in OpenAPI specification ruleset:

    Ruleset extension: extends: "spectral:oas"

2.  Spectral rules with core functions
3.  Spectral rules with customized<a href="https://github.com/camaraproject/Commonalities/blob/main/artifacts/linting_rules/lint_function"> JavaScript Functions</a>

## API Linting configuration steps for local

1.  Install spectral locally

        npm install -g @stoplight/spectral

2.  Intall spectral function locally.

        npm install --save @stoplight/spectral-functions

3.  Save files locally:

    Save "Spectral.yml" file (contains Linting rules) and lint_function folder (contains JavaScript customized functions) at the root location.

4.  Apply spectral rules on API specification loacally

        spectral lint openapi.yaml --verbose --ruleset .spectral.yml

    Replace 'openapi.yaml' with the path to your OpenAPI specification file
