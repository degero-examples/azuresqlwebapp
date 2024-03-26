@description('sql servername')
param sqlServerName string

@description('sql databasename')
param databaseName string

@description('sql admin user')
param sqlAdminUser string

@description('sql admin pass')
param sqlAdminPass string

@description('webappname')
param webAppName string

@description('appinsights name')
param applicationInsightsName string

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

resource webapp 'Microsoft.Web/sites@2023-01-01' existing = {
  name: webAppName
}

resource webSiteConnectionStrings 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: webapp
  name: 'connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Server=tcp:${sqlServerName}.privatelink${az.environment().suffixes.sqlServerHostname},1433;Initial Catalog=${databaseName};User Id=${sqlAdminUser};Password=${sqlAdminPass};TrustServerCertificate=True;Connection Timeout=30;'
      type: 'SQLAzure'
    }
  }
}

var settings = {
  APPLICATIONINSIGHTS_CONNECTION_STRING: applicationInsights.properties.ConnectionString
  WEBSITE_RUN_FROM_PACKAGE: '1'
}

resource functionAppSettings 'Microsoft.Web/sites/config@2021-03-01' = {
  parent: webapp
  name: 'appsettings'
  properties: settings
}
