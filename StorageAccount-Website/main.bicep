
//lesson 1 for param and var
param appServiceAppname string = 'toy-product-launch-1'
var appServicePlanname string = 'toy-product-launch-plan-starter'



//lesson 2 for param and var
param location string = resourceGroup().location


resource storageAccount 'Microsoft.Storage/storageAccounts@2025-08-01' = {
  name: 'toylaunchstorage'
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name:'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appServicePlanname
  location: 'eastus'
  sku: {
    name: 'F1'
  }
}


resource appServiceApp 'Microsoft.web/sites@2024-04-01' = {
  name: appServiceAppname
  location: 'eastus'
  properties: {
  serverFarmId: appServicePlan.id
  httpsOnly: true
  } 

}


resource sta 'Microsoft.Storage/storageAccounts@2026-04-01' = [for item in list: {
  
}]
