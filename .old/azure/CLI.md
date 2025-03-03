# AZ CLI

## App Service

### Logs

```shell
# Tail
az webapp log tail  --resource-group learn-2c8af4a6-ea4f-47e9-9104-7969785ce1d6 --name contosofashions25454

# Download
az webapp log download --log-file contosofashions.zip  --resource-group learn-2c8af4a6-ea4f-47e9-9104-7969785ce1d6 --name contosofashions25454
```
