resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'dev-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: 'dev-appServicePlan'
  location: resourceGroup().location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
}

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: 'unique-dev-webapp' // Ensure this name is unique
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'devcloud-sqlserver'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'P@ssw0rd'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: 'devcloud-database'
  parent: sqlServer
  location: resourceGroup().location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
    requestedServiceObjectiveName: 'S0'
  }
}
