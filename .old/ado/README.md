# ADO

## Pipeline

To use a variable set in a previous stage as a conditonal:

```yaml
condition: eq(stageDependencies.{stageName}.outputs['{jobName}.{stepName}.{variableName}'], 'value')
```
Note: remove all `{}` from above

## Management

- [Create Azure DevOps Management Reports](https://devblogs.microsoft.com/devops/create-azure-devops-management-reports/)
