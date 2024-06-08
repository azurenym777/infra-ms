targetScope = 'subscription'

param rgName string
param rgLocation string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-01-01' = {
  name: rgName
  location: rgLocation
  //properties: {}
}

output rg_id string = resourceGroup.id
output rg_name string = resourceGroup.name
output rg_location string = resourceGroup.location


-------------------------------------

targetScope = 'subscription'
param rgName string
param rgLocation string
param tags object = {
}

resource rg 'Microsoft.Resources/resourceGroups@2018-05-01' = {
  location: rgLocation
  name: rgName
  properties: {
  }
  tags: tags
}

