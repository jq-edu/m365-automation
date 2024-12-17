#
# Module manifest for module 'CustomAutomationModule'
#
# Generated by: Joel Quimper
#
# Generated on: 2024-12-16
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'CustomAutomationModule.psm1'

# Version number of this module.
ModuleVersion = '0.0.2'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '12fae585-4078-49ea-93de-52f2a0104aa7'

# Author of this module
Author = 'Joel Quimper'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) joelquimper. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Provided as is with no waranty or support.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '7.0'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(@{ModuleName = 'Microsoft.PowerShell.SecretManagement'; RequiredVersion = '1.1.2'; },
                    @{ModuleName = 'Microsoft.Graph.Authentication'; RequiredVersion = '2.25.0'; })

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no function to export.
FunctionsToExport = "Connect-GraphContext"

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

}

