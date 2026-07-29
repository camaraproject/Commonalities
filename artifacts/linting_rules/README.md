Linting rules and their usage documentation are maintained within CAMARA [tooling repository](https://github.com/camaraproject/tooling/tree/main/linting).

## Linting of the artifacts in this repository

The [Artifacts Lint workflow](../../.github/workflows/artifacts-lint.yml) runs on every pull request and on pushes to `main`:

- **yamllint** over all YAML files in `artifacts/` (including `Github_templates/`, whose installed copies in API repositories are not checked there)
- **Spectral** over the full-OpenAPI templates (`api-templates/`, `notification-templates/`) with the CAMARA ruleset of the release line under development; `$ref` resolution transitively checks the referenced definitions in `common/`
- **gplint** over the Gherkin feature templates (`testing/`)

Lint configurations, rule metadata and tool versions are taken from the [tooling repository](https://github.com/camaraproject/tooling/tree/main/linting) at the same pinned ref API repositories use for CAMARA Validation, so findings here match the validation toolchain.

All three checks block only on error-level findings; warnings and hints are reported but do not fail the check.

Each template is linted in its own Spectral invocation, because Spectral loses the source file of most findings when several input files share `$ref` targets ([stoplightio/spectral#2640](https://github.com/stoplightio/spectral/issues/2640)). A finding in `common/` is therefore reported once per template that references it, and the raw count in the per-template log output is several times the number of distinct findings. The step reconciles the two in a table it writes both to the log and to the run summary.

### Expected lint findings

Artifacts in this repository are held to the same standard as API definitions: fix a finding, or document why it stays. The findings below are the documented baseline — they are expected, and a pull request is not asked to resolve them. Anything a check reports beyond this list was introduced by the change under review.

Findings in this list that are recorded as known-unactionable in the CAMARA Validation rule metadata are collapsed by the workflow into a single `notice` annotation per file, pointing back at this section. The remainder keep an individual annotation, so they stay visible until they are resolved.

#### Spectral: `owasp:api4:2023-string-restricted`

Fifteen findings, all of the same kind: a string field that already constrains its length via `maxLength` but has no `format`, `pattern`, `enum` or `const`, because none of those would carry meaning for a free-text or externally-defined identifier value.

Ten of them — the `common/` fields other than the pagination `Link` header — are listed in the `suppress_schema_paths` allowlist of rule S-313 in the [tooling rule metadata](https://github.com/camaraproject/tooling/blob/main/validation/rules/spectral-rules.yaml), which is where API repositories already suppress them. The workflow reads that allowlist directly rather than keeping a copy, so this list and CAMARA Validation cannot drift apart. The allowlist names individual fields rather than whole schemas, so a newly added unconstrained string in a common schema still surfaces on its own and can be judged on its own merits.

| Field | Annotation |
| --- | --- |
| `common/CAMARA_common.yaml` → `components.headers.link.schema` | individual |
| `common/CAMARA_common.yaml` → `components.schemas.ErrorInfo.properties.code` | collapsed |
| `common/CAMARA_common.yaml` → `components.schemas.ErrorInfo.properties.message` | collapsed |
| `common/CAMARA_common.yaml` → `components.schemas.NetworkAccessIdentifier` | collapsed |
| `common/CAMARA_event_common.yaml` → `components.schemas.CloudEvent.properties.id` | collapsed |
| `common/CAMARA_event_common.yaml` → `components.schemas.CloudEvent.properties.type` | collapsed |
| `common/CAMARA_event_common.yaml` → `components.schemas.SubscriptionId` | collapsed |
| `common/CAMARA_event_common.yaml` → `components.schemas.HTTPSettings.properties.headers.additionalProperties` | collapsed |
| `common/CAMARA_event_common.yaml` → `components.schemas.SubscriptionStarted.properties.initiationDescription` | collapsed |
| `common/CAMARA_event_common.yaml` → `components.schemas.SubscriptionUpdated.properties.updateDescription` | collapsed |
| `common/CAMARA_event_common.yaml` → `components.schemas.SubscriptionEnded.properties.terminationDescription` | collapsed |
| `api-templates/sample-service.yaml` → `components.schemas.CreateResource.properties.name` | individual |
| `api-templates/sample-service.yaml` → `components.schemas.Resource.properties.name` | individual |
| `api-templates/sample-implicit-events.yaml` → `components.schemas.CreateResource.properties.name` | individual |
| `api-templates/sample-implicit-events.yaml` → `components.schemas.Resource.properties.name` | individual |

The two groups that are annotated individually are the ones not covered by the allowlist:

- The pagination `Link` header in `CAMARA_common.yaml` holds an RFC 8288 header value, which has a defined syntax but no OpenAPI `format` for it. Adding it to the S-313 allowlist is tracked in [camaraproject/tooling#401](https://github.com/camaraproject/tooling/issues/401); once that lands the workflow collapses it with the rest, with no change needed here.
- The `name` fields of the sample resources in the API templates are placeholder content of the templates themselves, not part of the common library, so they are outside the scope of an allowlist meant for `common/`.

The scope of the OWASP string rules is discussed more broadly in [#596](https://github.com/camaraproject/Commonalities/issues/596); this section records the current state and follows whatever that discussion resolves.

### When a check fails

- The finding points at a real problem in the changed artifact (parse error, violated convention): fix the content.
- The artifact is intentional and the rule itself no longer matches a Commonalities convention: the rules live in the tooling repository, so open a paired change there — the tooling change merges first, then the change in this repository lints green.
