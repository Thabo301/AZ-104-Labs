# --- Variables ---
# We define our names and settings here for easy changes later.
$resourceGroupName = "Lab-RG"
$location = "EastUS"
$vnetName = "VNet-PS"
$vnetAddressPrefix = "10.1.0.0/16"
$subnetName = "Subnet-A"
$subnetAddressPrefix = "10.1.1.0/24"

# --- Script Execution ---
Write-Host "Starting VNet deployment: $vnetName in resource group: $resourceGroupName..."

# In PowerShell, we first define the configuration for the subnet...
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
    -Name $subnetName `
    -AddressPrefix $subnetAddressPrefix

# ...then we create the Virtual Network and pass in the subnet configuration.
New-AzVirtualNetwork `
    -Name $vnetName `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -AddressPrefix $vnetAddressPrefix `
    -Subnet $subnetConfig

Write-Host "✅ PowerShell VNet deployment complete!"