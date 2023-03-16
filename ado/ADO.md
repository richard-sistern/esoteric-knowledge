# ADO

## Pipeline

To use a variable set in a previous stage as a conditonal:

```yaml
condition: eq(stageDependencies.{stageName}.outputs['{jobName}.{stepName}.{variableName}'], 'value')
```
Note: remove all `{}` from above
