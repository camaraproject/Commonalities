# CAMARA syntax cheatsheet

<!--Note for PR#320: The text below is an example for illustration
and is incomplete. If the PR is approved then anyone can suggest additions.

The intention is for this cheatsheet to be expanded to 
incorporate all design guidelines that can be quickly represented
(such as syntax conventions). More detailed guidelines would only
appear in the main design guidelines document.
-->

## Case conventions

| Information item | Convention | Example | 
|------------------|------------|---------|
| API name | kebab-case | simple-edge-discovery |
| OAS file name | kebab-case | simple-edge-discovery.yaml |
| Path| kebab-case | `/customer-segments` |
| OperationId | camelCase | getData | 

## Scopes
- Structure: `api-name:[resource:]action`
- Format: kebab-case, colon separated
- Example: `qod:qos-profiles:read`
