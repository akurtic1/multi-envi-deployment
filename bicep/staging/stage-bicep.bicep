resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'dev-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.1.0.0/16']
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: 'stage-appServicePlan'
  location: resourceGroup().location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
}

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: 'unique-stage-webapp' // Ensure this name is unique
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'stage-sqlserver'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'P@ssw0rd'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: 'stage-database'
  parent: sqlServer
  location: resourceGroup().location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
    requestedServiceObjectiveName: 'S0'
  }
}
