// === Parameters ===
// These are the inputs needed to deploy the VM.
@description('The name of the existing VNet to deploy the VM into.')
param existingVnetName string = 'VNet-PS'

@description('The name of the subnet to deploy the VM into.')
param existingSubnetName string = 'Subnet-A'

@description('The name of your Virtual Machine.')
param vmName string = 'VM-Bicep'

@description('Admin username for the VM.')
param adminUsername string

@description('Admin password for the VM. Must be at least 12 characters long and meet complexity requirements.')
@secure()
param adminPassword string

@description('The location for the resources.')
param location string = resourceGroup().location

// === Variables ===
// We create some resource names based on the VM name for consistency.
var networkInterfaceName = '${vmName}-nic'
var publicIpAddressName = '${vmName}-pip'
var networkSecurityGroupName = '${vmName}-nsg'

// === Existing Resources ===
// This tells Bicep to find the virtual network and subnet you already created.
resource existingVnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: existingVnetName
  resource existingSubnet 'subnets' existing = {
    name: existingSubnetName
  }
}

// === New Resources ===
// These are the new resources that Bicep will create.

// A Public IP so we can connect to the VM from the internet.
resource publicIpAddress 'Microsoft.Network/publicIpAddresses@2021-08-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// A Network Security Group (NSG) to act as a firewall.
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '3389' // Port for Remote Desktop Protocol
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// A Network Interface Card (NIC) to connect the VM to the VNet.
resource networkInterface 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddress.id
          }
          subnet: {
            id: existingVnet::existingSubnet.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

// The Virtual Machine itself.
resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s' // A small, cost-effective size
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}