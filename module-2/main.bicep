@description('The name of the environment. This must be dev, test or prod.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentType string 


@description('the unique name of the solution. This is used to ensure that resource names are unique')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'


@description('The number of App Service Plan instances')
@minValue(1)
@maxValue(10)

param appServicePlanInstanceCount int = 1

@description('the name and tier of the App Service plan SKU.')
param appServicePlanSKU object = {
  name: 'F1'
  tier: 'Free'

}

@secure()
@description('the administrator login username for the SQL server')
param sqlServerAdministratorLogin string

@secure()
@description('the administrator login password for the SQL server')
param sqlServerAdministratorPassword string

@description('the name and tier of the SQL database SKU')
param sqlDatabaseSku object



@description('same location of resource group')
param location string = resourceGroup().location



@description('list of storageaccount SKU')
param storageAccountProperties object = {
  sku: 'Standard_LRS'
  kind: 'StorageV2'
  accesstier: 'hot'
}

@description('resource tags')
param tags object = {
  createdby: 'rom john'
  date: 'May 8'
  purpose: 'for better life and For God'
}

var appServicePlanName = '${environmentType}-${solutionName}-plan'
var appServiceName = '${environmentType}-${solutionName}-app'
var sqlDatabaseName = 'Employees'
var sqlServerName = '${environmentType}-${solutionName}-sql'
var auditStorageAccountName = take('beartoy${uniqueString(resourceGroup().id)}',24)
var auditingEnabled = environmentType == 'prod'


resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}


resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSKU.name
    tier: appServicePlanSKU.tier
    capacity: appServicePlanInstanceCount
  }
  tags: tags
}

resource appServiceApp 'Microsoft.Web/sites@2025-03-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
    tags: tags
}


resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2025-08-01' = if (auditingEnabled) {
  name: auditStorageAccountName
  location: location
  sku: {
    name: storageAccountProperties.sku
  }
  kind: storageAccountProperties.kind
  tags: tags  
}


resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2025-02-01-preview' = if (auditingEnabled) {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: environmentType == 'prod' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: environmentType == 'prod' ? auditStorageAccount.listKeys().keys[0].value : ''
  }
}


output appServiceApp string = appServiceApp.properties.defaultHostName 
output appServiceID string = appServicePlan.id
output appServiceInstance int = appServicePlan.sku.capacity
output primaryEndpoints string = sqlServerAudit.properties.storageEndpoint
output sqlServerAuditName string = sqlServerAudit.name
