@description('tags')
param tags object = {}

@description('vnet name')
param vnetName string

param dbPrivateLink string = 'privatelink${az.environment().suffixes.sqlServerHostname}'

resource privateDnsZones_Db 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: dbPrivateLink
  location: 'global'
  tags: tags
}

resource privateDnsZones_Db_NetName 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  parent: privateDnsZones_Db
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnetName
}

resource privateDnsZones_privatelink_database_windows_net_name_rxkcl4ynxck36 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_Db
  tags: tags
  name: uniqueString(resourceGroup().id)
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}
