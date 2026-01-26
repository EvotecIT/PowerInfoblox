@{
    AliasesToExport      = @('Add-InfobloxSubnet', 'Get-InfobloxDHCPLeases', 'Get-InfobloxDNSAuthZones', 'Get-InfobloxDNSRecords', 'Get-InfobloxDNSRecordsAll', 'Set-InfobloxMembers')
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2026 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Helper module for Infoblox.'
    FunctionsToExport    = @('Add-InfobloxDHCPRange', 'Add-InfobloxDHCPRangeOptions', 'Add-InfobloxDHCPReservation', 'Add-InfoBloxDNSRecord', 'Add-InfobloxFixedAddress', 'Add-InfobloxNetwork', 'Add-InfobloxNetworkExtensibleAttribute', 'Connect-Infoblox', 'Disconnect-Infoblox', 'Get-InfobloxDHCPLease', 'Get-InfobloxDHCPRange', 'Get-InfobloxDiscoveryTask', 'Get-InfobloxDNSAuthZone', 'Get-InfobloxDNSDelegatedZone', 'Get-InfobloxDNSForwardZone', 'Get-InfobloxDNSRecord', 'Get-InfobloxDNSRecordAll', 'Get-InfobloxDNSView', 'Get-InfobloxFixedAddress', 'Get-InfobloxGrid', 'Get-InfobloxIPAddress', 'Get-InfobloxMember', 'Get-InfobloxNetwork', 'Get-InfobloxNetworkContainer', 'Get-InfobloxNetworkNextAvailableIP', 'Get-InfobloxNetworkNextAvailableNetwork', 'Get-InfobloxNetworkView', 'Get-InfobloxObjects', 'Get-InfobloxPermission', 'Get-InfobloxResponsePolicyZones', 'Get-InfobloxSchema', 'Get-InfoBloxSearch', 'Get-InfobloxVDiscoveryTask', 'Invoke-InfobloxQuery', 'New-InfobloxOption', 'Remove-InfobloxDHCPRangeOptions', 'Remove-InfobloxDnsRecord', 'Remove-InfobloxFixedAddress', 'Remove-InfobloxIPAddress', 'Remove-InfobloxNetworkExtensibleAttribute', 'Remove-InfobloxObject', 'Set-InfobloxDHCPRange', 'Set-InfobloxDHCPRangeOptions', 'Set-InfobloxDNSRecord', 'Set-InfobloxNetworkMembers')
    GUID                 = '9fc9fd61-7f11-4f4b-a527-084086f1905f'
    ModuleVersion        = '1.0.33'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            ExternalModuleDependencies = @('Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Security')
            ProjectUri                 = 'https://github.com/EvotecIT/PowerInfoblox'
            RequireLicenseAcceptance   = $false
            Tags                       = @('Windows', 'Infoblox')
        }
    }
    RequiredModules      = @(@{
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
            ModuleName    = 'PSSharedGoods'
            ModuleVersion = '0.0.312'
        }, 'Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Security')
    RootModule           = 'PowerInfoblox.psm1'
}