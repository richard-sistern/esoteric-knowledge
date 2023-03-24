# Bicep

## Commands

Deploy Bicep template to storage-resource-group
```bash
az deployment group create --template-file ./main.bicep --resource-group storage-resource-group
```

View the JSON template Bicep submits to Resource manager
```bash
bicep build ./main.bicep
```

## Resources

[Fundamentals of Bicep](https://docs.microsoft.com/en-us/learn/paths/fundamentals-bicep/)
