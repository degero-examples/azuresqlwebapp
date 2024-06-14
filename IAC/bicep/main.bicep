@description('location for function app resources')
param location string = resourceGroup().location

@description('App name')
param appName string = 'examplwebsql'

@description('environment')
@allowed([
  'dev'
  'stage'
  'prod'
])
param env string

@description('tags')
param tags object = {
  environment: env
  appname: appName
}

@description('sql servername')
param sqlServerName string = resourceGroup().location

@description('sql databasename')
param databaseName string

@description('sql server user')
param sqlServerUser string

@description('sql server pass')
param sqlServerPass string

module appInsights './appinsights.bicep' = {
  name: 'appInsights'
  params: {
    location: location
    tags: tags
    env: env
    appName: appName
  }
}

module vnet './vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    tags: tags
    env: env
    appName: appName
  }
}

module appService './appservice.bicep' = {
  name: 'appService'
  params: {
    location: location
    tags: tags
    env: env
    appName: appName
  }
}

module appServiceConfig './appservice.config.bicep' = {
  name: 'appServiceConfig'
  params: {
    applicationInsightsName: appInsights.outputs.name
    databaseName: databaseName
    sqlAdminUser: sqlServerUser
    sqlAdminPass: sqlServerPass
    sqlServerName: sqlServerName
    webAppName: appService.outputs.name
  }
}

module privateLink './privatelink.bicep' = {
  name: 'privateLink'
  params: {
    tags: tags
    vnetName: vnet.outputs.name
  }
}

output funcAppSettings object = appServiceConfig.outputs.funcAppSettings
