
var storageAccountname = 'toy${parstorageAccountname}'
param parstorageAccountname string 

param resourceTags object = {
  CreatedBy: 'Rom John Awacay'
  Purpose: 'For better life and For God'
}


var regions = [
  'southeastasia'
  'westeurope'
  'northeurope'
]


@allowed ([
  'nonprod'
  'prod'
])
param environmentType string 

var storageAccountSKUname = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'


resource storageAccount 'Microsoft.Storage/storageAccounts@2025-08-01' = [ for (region,i) in regions: {
  name: '${storageAccountname}${i}'
  location: region
  kind: 'StorageV2'
  tags: resourceTags
  sku:{
    name: storageAccountSKUname
      }
      properties: {
        accessTier: 'Cold'
      }
}]


output storageAccountname string = storageAccountname
output resource_group string = resourceGroup().name
