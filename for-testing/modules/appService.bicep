
param location string
param parwebAppName string
param parwebAppPlanName string


param resourceTags object = {
  CreatedBy: 'Rom John Awacay'
  Purpose: 'For better life and For God'
}



@allowed ([
  'nonprod'
  'prod'
])
param environmentType string


var webAppName = 'web-toy-${parwebAppName}'
var webAppPlanName = 'web-${parwebAppPlanName}'
var serviceAppPlanSKUname = (environmentType == 'prod') ? 'B1' : 'F1'

resource serviceAppPlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: webAppPlanName
  location: location
  tags: resourceTags
  sku: {
    name: serviceAppPlanSKUname
  }
}


resource serviceAppname 'Microsoft.Web/sites@2025-03-01' = {
  name: webAppName
  location: location
  tags: resourceTags
    properties: {
      serverFarmId: serviceAppPlan.id
      httpsOnly: true
    }
}



output resource_group string = resourceGroup().name
output webAppname string = webAppName
output serviceAppnameid string = serviceAppname.id
output webAppDefaulthostname string = serviceAppname.properties.defaultHostName
