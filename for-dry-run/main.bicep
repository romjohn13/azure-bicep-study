param storageAccountDetails array = [
  {
    name: 'storageaccount'
    location: 'southeastasia'
    sku: 'Standard_LRS'
    kind: 'StorageV2'
    accesstier: 'Cold'
    environmenttype: 'prod'
  }
  {
    name: 'storageaccount'
    location: 'eastasia'
    sku: 'Standard_GRS'
    kind: 'StorageV2'
    accesstier: 'Cold'
    environmenttype: 'dev'
  }
  {
    name: 'storageaccount'
    location: 'westeurope'
    sku: 'Standard_GRS'
    kind: 'StorageV2'
    accesstier: 'Cold'
    environmenttype: 'test'
  }
]
param targetEnvironment string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-08-01' = [ for storageAccount in storageAccountDetails: if (storageAccount.environmenttype == targetEnvironment) {
  name: '${storageAccount.environmenttype}${uniqueString(resourceGroup().id)}'
  location: storageAccount.location
  kind: storageAccount.kind
  sku:{
    name: storageAccount.sku
  }
  properties:{
    accessTier: storageAccount.accesstier 
  }
  tags: {
    environment: storageAccount.environmenttype
    }
  }
]
