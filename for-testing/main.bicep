
//var prefix = 'p'
//var storageAccountname = '${prefix}20260426storageaccount'


param parstorageAccountname string = 'st${uniqueString(resourceGroup().id)}'
param parwebAppPlanName string = 'plan-${uniqueString(resourceGroup().id)}-001'
param parwebAppname string = '${uniqueString(resourceGroup().id)}-001'
param location string = resourceGroup().location

//create multiple resource in the region below
@allowed ([
  'nonprod'
  'prod'
])
param environmentType string 


module appServiceModule 'modules/appService.bicep' = {
  name: 'appServiceModule'
  params: {
    location: location
    environmentType: environmentType
    parwebAppPlanName: parwebAppPlanName
    parwebAppName: parwebAppname
  }
}


module storageAccountModule 'modules/storageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    environmentType: environmentType
    parstorageAccountname: parstorageAccountname
  }
}


output webAppname string = appServiceModule.outputs.webAppname
output webAppURL string = appServiceModule.outputs.webAppDefaulthostname
output storageAccountName string = storageAccountModule.outputs.storageAccountname
