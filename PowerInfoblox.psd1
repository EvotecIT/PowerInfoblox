@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2023 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Helper module for Infoblox.'
    FunctionsToExport    = @('Connect-Infoblox', 'Get-InfobloxNetwork', 'Get-InfobloxNextAvailableIP', 'Get-InfobloxSchema', 'Invoke-InfobloxQuery')
    GUID                 = '9fc9fd61-7f11-4f4b-a527-084086f1905f'
    ModuleVersion        = '0.0.0'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            ExternalModuleDependencies = @('Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Security')
            ProjectUri                 = 'https://github.com/EvotecIT/PowerInfoblox'
            Tags                       = @('Windows', 'Infoblox')
        }
    }
    RequiredModules      = @(@{
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
            ModuleName    = 'PSSharedGoods'
            ModuleVersion = '0.0.266'
        }, 'Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Security')
    RootModule           = 'PowerInfoblox.psm1'
}