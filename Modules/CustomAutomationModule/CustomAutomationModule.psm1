<#
.SYNOPSIS
    Fonction de connexion à Microsoft Graph.

.DESCRIPTION
    Cette fonction permet de se connecter à Microsoft Graph en mode "application" et en utilisant les informations
    d'identification stockées dans Azure Key Vault.  Cette fonction est utilisée pour simplifier la connexion en 
    fonctionnant autant en mode interactif (dans VS Code pour "débugger", sur un serveur local...) que dans Azure Automation.

    Afin de se connecter en utilisant l'environnement, il est nécessaire de définir les variables suivantes:
    - KEYVAULT_NAME
    - KEYVAULT_SUBSCRIPTION_ID
    En mode interactif, simplement les ajouter comme variables d'environnement. En mode Azure Automation, elle doivent 
    être ajoutées dans les variables qui sont sous "Shared Resources".

.PARAMETER KeyVaultName
    Nom du Key Vault Azure contenant les secrets d'identification pour se connecter à Microsoft Graph.  Si non spécifié, 
    la fonction tentera de se connecter en utilisant des variables de l'environnement.

.PARAMETER SubscriptionId    
    ID de l'abonnement Azure contenant le Key Vault.  Si non spécifié, la fonction tentera de se connecter en utilisant 
    des variables de l'environnement.

.NOTES
    Auteur: Joël Quimper
    Date: 2024-12-02
#>
function Connect-GraphContext {
    param (
        [Parameter(Mandatory = $false)]
        [string]$KeyVaultName,

        [Parameter(Mandatory = $false)]
        [string]$SubscriptionId
    )

    # Get az connection to access to Azure Key Vault based if you are running in Azure Automation or locally
    try
    {
        if (-not $env:AZUREPS_HOST_ENVIRONMENT) {
            "Running Locally (Interactively)"
            if (-not $KeyVaultName) {
                "No KeyVaultName provided, checking environment variable." 
                $KeyVaultName = $env:KEYVAULT_NAME 
            }
            if (-not $SubscriptionId) {
                "No SubscriptionId provided, checking environment variable." 
                $SubscriptionId = $env:KEYVAULT_SUBSCRIPTION_ID 
            }
            
            # Exit if KeyVaultName or SubscritionId is null
            if (-not $KeyVaultName -or -not $SubscriptionId) {
                Write-Error -Message "KeyVaultName and SubscriptionId are required."
                throw "KeyVaultName and SubscriptionId are required."
            }

            Connect-AzAccount
        } else {
            "Running in Azure Automation"
            if (-not $KeyVaultName) {
                "No KeyVaultName provided, checking automation shared settings variable." 
                $KeyVaultName = Get-AutomationVariable -Name KEYVAULT_NAME 
            }
            if (-not $SubscriptionId) {
                "No SubscriptionId provided, checking automation shared settings variable." 
                $SubscriptionId = Get-AutomationVariable -Name KEYVAULT_SUBSCRIPTION_ID 
            }

            # Exit if KeyVaultName or SubscritionId is null
            if (-not $KeyVaultName -or -not $SubscriptionId) {
                Write-Error -Message "KeyVaultName and SubscriptionId are required."
                throw "KeyVaultName and SubscriptionId are required."
            }

            Connect-AzAccount -Identity
        }

        

        # First check if Register-SecretVault AzKV is already registered
        $registeredVaults = Get-SecretVault
        if ($registeredVaults.Name -contains $KeyVaultName) {
            "$KeyVaultName vault is already registered."
        } else {
            "Registering $KeyVaultName vault."
            $VaultParameters = @{
                AZKVaultName = $KeyVaultName
                SubscriptionId = $SubscriptionId
            }
            Register-SecretVault -Module Az.KeyVault -Name $KeyVaultName -VaultParameters $VaultParameters
        }

        $tenantId = Get-Secret -Name tenantId -Vault $KeyVaultName -AsPlainText
        $clientId = Get-Secret -Name clientId -Vault $KeyVaultName -AsPlainText
        $SecuredPasswordPassword = Get-Secret -Name clientSecret -Vault $KeyVaultName -AsPlainText | ConvertTo-SecureString -AsPlainText -Force
        $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $SecuredPasswordPassword

        # Connect to Microsoft Graph
        "Connecting to graph with clientId: " + $clientId + " and tenantId: " + $tenantId
        return Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential
    }
    catch {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

Export-ModuleMember Connect-GraphContext
