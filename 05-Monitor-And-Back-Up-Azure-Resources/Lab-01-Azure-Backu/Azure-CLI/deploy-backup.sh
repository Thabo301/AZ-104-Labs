#!/bin/bash
# --- Configuration ---
resourceGroupName="Lab-RG"
location="EastUS"
# Vault name must be unique, so we use a random number
vaultName="vault-cli-$RANDOM"
policyName="Daily-Backup-Policy-CLI"

# --- Script Execution ---
echo "Starting Azure Backup deployment..."

# Create the Recovery Services Vault
echo "Creating Recovery Services Vault: $vaultName..."
az backup vault create --resource-group $resourceGroupName \
    --name $vaultName \
    --location $location

# Create a new backup protection policy
echo "Creating Backup Policy: $policyName..."
az backup policy create --resource-group $resourceGroupName \
    --vault-name $vaultName \
    --name $policyName \
    --backup-management-type AzureIaasVM

echo "✅ Azure CLI Backup Infrastructure deployment complete!"
echo "Vault Created: $vaultName"