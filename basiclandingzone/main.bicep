@description('Name of the Landing Zone Resources')
param name string = ''

@description('Location to deploy the environment resources')
param location string = resourceGroup().location

resource vnetapp 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'vnet-${name}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-app'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
      {
        name: 'snet-endpoints'
        properties: {
          addressPrefix: '10.1.2.0/24'
        }
      }
    ]
  }
}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-${name}-${substring(uniqueString(resourceGroup().id), 0,4)}'
  location: location
  properties: {
    enabledForTemplateDeployment: true
    createMode: 'default'
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    
  }
}
