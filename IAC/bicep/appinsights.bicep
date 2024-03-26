@description('location for appinsights')
param location string = resourceGroup().location

@description('tags')
param tags object = {}

@description('App name')
param appName string

@description('environment')
@allowed([
  'dev'
  'stage'
  'prod'
])
param env string

var appInsightsName = 'appinsights-${appName}-${env}'

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

output name string = appInsightsName
