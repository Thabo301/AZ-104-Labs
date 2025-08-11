#!/bin/bash
# --- Variables ---
# We define our names and settings here for easy changes later.
resourceGroupName="Lab-RG"
location="EastUS"
vnetName="VNet-CLI"
vnetAddressPrefix="10.2.0.0/16"
subnetName="Subnet-A"
subnetAddressPrefix="10.2.1.0/24"

# --- Script Execution ---
echo "Starting VNet deployment: $vnetName in resource group: $resourceGroupName..."

# The Azure CLI command is more direct and can create the VNet and subnet in one go.
az network vnet create \
    --resource-group $resourceGroupName \
    --name $vnetName \
    --address-prefix $vnetAddressPrefix \
    --subnet-name $subnetName \
    --subnet-prefix $subnetAddressPrefix

echo "✅ Azure CLI VNet deployment complete!"