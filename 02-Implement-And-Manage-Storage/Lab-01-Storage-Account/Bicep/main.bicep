@description('The unique name of the Azure Storage account.')
param storageAccountName string = 'stbicep20250812'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: 'EastUS'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}