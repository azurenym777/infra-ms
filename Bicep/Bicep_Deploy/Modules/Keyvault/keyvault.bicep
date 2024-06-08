targetScope = 'resourceGroup'

param keyvaultName string

param rglocation string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyvaultName
  location: rglocation
  properties: {
    accessPolicies: []
    enabledforDeployment: false
    enabledforDiskEncryption: false
    enabledforTemplateDeployment: false
    enableSoftDelete: true
    enablePurgeProtection: true
    softDeleteRetentionInDays: 90
    publicNetworkAccess: 'Disabled'
    tenantId: subscription().tenantId
    vaultUri: http://
    sku {
      name: 'standard'
      family:  'A'
    }
    networkAcls: {
      iprules: []
      virtualNetworkRules: []
      defaultActions: 'Deny'
      bypass: 'AzureServices'

    }

  }
}

output kv_id string = keyVault.id
output kv_uri string = keyVault.properties.vaulturi
