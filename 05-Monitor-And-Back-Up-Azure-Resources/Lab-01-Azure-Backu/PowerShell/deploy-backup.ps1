# --- Configuration ---
$resourceGroupName = "Lab-RG"
$location = "EastUS"
$vaultName = "Vault-PS" # Must be globally unique, so let's add a random number
$vaultName = $vaultName + (Get-Random -Maximum 99999)

$policyName = "Daily-Backup-Policy-PS"

# --- Script Execution ---
Write-Host "Starting Azure Backup deployment..."

# Create the Recovery Services Vault
Write-Host "Creating Recovery Services Vault: $vaultName..."
New-AzRecoveryServicesVault -Name $vaultName -ResourceGroupName $resourceGroupName -Location $location

# Set the vault context, which tells subsequent commands which vault to work with
Get-AzRecoveryServicesVault -Name $vaultName | Set-AzRecoveryServicesVaultContext

# Create a new backup protection policy
Write-Host "Creating Backup Policy: $policyName..."
New-AzRecoveryServicesBackupProtectionPolicy -Name $policyName -WorkloadType AzureVM -RetentionPolicy (Get-AzRecoveryServicesBackupRetentionPolicyObject -WorkloadType AzureVM) -SchedulePolicy (Get-AzRecoveryServicesBackupSchedulePolicyObject -WorkloadType AzureVM)

Write-Host "✅ PowerShell Backup Infrastructure deployment complete!"
Write-Host "Vault Created: $vaultName"