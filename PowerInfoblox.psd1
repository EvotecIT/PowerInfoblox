@{
    AliasesToExport      = @('Get-InfobloxDHCPLeases', 'Get-InfobloxDNSAuthZones', 'Get-InfobloxDNSRecords', 'Get-InfobloxDNSRecordsAll')
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2024 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Helper module for Infoblox.'
    FunctionsToExport    = @('Add-InfoBloxDNSRecord', 'Add-InfobloxFixedAddress', 'Connect-Infoblox', 'Disconnect-Infoblox', 'Get-InfobloxDHCPLease', 'Get-InfobloxDHCPRange', 'Get-InfobloxDiscoveryTask', 'Get-InfobloxDNSAuthZone', 'Get-InfobloxDNSDelegatedZone', 'Get-InfobloxDNSForwardZone', 'Get-InfobloxDNSRecord', 'Get-InfobloxDNSRecordAll', 'Get-InfobloxDNSView', 'Get-InfobloxFixedAddress', 'Get-InfobloxGrid', 'Get-InfobloxIPAddress', 'Get-InfobloxMember', 'Get-InfobloxNetwork', 'Get-InfobloxNetworkNextAvailableIP', 'Get-InfobloxNetworkView', 'Get-InfobloxObjects', 'Get-InfobloxPermission', 'Get-InfobloxResponsePolicyZones', 'Get-InfobloxSchema', 'Get-InfoBloxSearch', 'Get-InfobloxVDiscoveryTask', 'Invoke-InfobloxQuery', 'Remove-InfobloxFixedAddress', 'Remove-InfobloxIPAddress', 'Remove-InfobloxObject', 'Set-InfobloxDNSRecord')
    GUID                 = '9fc9fd61-7f11-4f4b-a527-084086f1905f'
    ModuleVersion        = '1.0.6'
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
            ModuleVersion = '0.0.278'
        }, 'Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Security')
    RootModule           = 'PowerInfoblox.psm1'
}