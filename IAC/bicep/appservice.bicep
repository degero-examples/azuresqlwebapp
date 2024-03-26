@description('location for appservice')
param location string = resourceGroup().location

@description('Name of app')
param appName string

@description('The environment')
@allowed([
  'dev'
  'stage'
  'prod'
])
param env string

@description('Tags')
param tags object = {}

var hostingPlanName = 'asp-${appName}-${env}'
var webAppName = 'app-${appName}-${env}'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: hostingPlanName
  location: location
  tags: tags
  sku: {
    name: 'F1'
    capacity: 0
  }
}

resource webapp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      alwaysOn: false
      netFrameworkVersion: 'v8.0'
    }
    httpsOnly: true
  }
}

output name string = webapp.name
