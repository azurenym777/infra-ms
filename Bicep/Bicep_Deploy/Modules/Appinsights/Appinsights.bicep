targetScope = 'resourceGroup'

param workspaceName string
param keyvaultName string
param appInsightsName string
param rglocation string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-03-01' = {
  name: workspaceName
  location: rglocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

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
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      iprules: []
      virtualNetworkRules: []
      defaultActions: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

resource keyVaultDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${keyvaultName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
  scope: keyVault
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: rglocation
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

output workspace_id string = logAnalyticsWorkspace.id
output workspace_name string = logAnalyticsWorkspace.name
output workspace_location string = logAnalyticsWorkspace.location

output kv_id string = keyVault.id
output kv_uri string = keyVault.properties.vaultUri

output appInsights_id string = appInsights.id
output appInsights_instrumentationKey string = appInsights.properties.InstrumentationKey
output appInsights_name string = appInsights.name
output appInsights_location string = appInsights.location
