resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-03-01' = {
  name: workspaceName
  location: rglocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
  }
}
