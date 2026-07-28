Linting rules and their usage documentation are maintained within CAMARA [tooling repository](https://github.com/camaraproject/tooling/tree/main/linting).

## Linting of the artifacts in this repository

The [Artifacts Lint workflow](../../.github/workflows/artifacts-lint.yml) runs on every pull request and on pushes to `main`:

- **yamllint** over all YAML files in `artifacts/` (including `Github_templates/`, whose installed copies in API repositories are not checked there)
- **Spectral** over the full-OpenAPI templates (`api-templates/`, `notification-templates/`) with the CAMARA ruleset of the release line under development; `$ref` resolution transitively checks the referenced definitions in `common/`
- **gplint** over the Gherkin feature templates (`testing/`)

Lint configurations and tool versions are taken from the [tooling repository](https://github.com/camaraproject/tooling/tree/main/linting/config) at the same pinned ref API repositories use for CAMARA Validation, so findings here match the validation toolchain.

All three checks block only on error-level findings; warnings and hints are reported in the workflow log but do not fail the check.

### When a check fails

- The finding points at a real problem in the changed artifact (parse error, violated convention): fix the content.
- The artifact is intentional and the rule itself no longer matches a Commonalities convention: the rules live in the tooling repository, so open a paired change there — the tooling change merges first, then the change in this repository lints green.
