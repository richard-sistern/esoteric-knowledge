param location string = 'westus3'
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2_v3' : 'F1'
var appServicePlanName = 'toy-product-launch-plan'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName 
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverFarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

// Connect-AzAccount

// $context = Get-AzSubscription -SubscriptionName 'Concierge Subscription'
// Set-AzContext $context

// Get-AzSubscription

// Set-AzDefault -ResourceGroupName learn-89a1dfc6-8a21-4852-a713-a71335b24370

// New-AzResourceGroupDeployment -TemplateFile main.bicep

// New-AzResourceGroupDeployment -TemplateFile examples/toy_demo.bicep -ResourceGroupName "learn-c6694696-2422-4b55-8c60-721ce6152960"

// New-AzResourceGroupDeployment -TemplateFile examples/toy_demo.bicep -ResourceGroupName "learn-c6694696-2422-4b55-8c60-721ce6152960" -environmentType nonprod
