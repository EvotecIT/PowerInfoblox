# PowerInfoblox - PowerShell Module

<p align="center">
  <!-- <a href="https://dev.azure.com/evotecpl/PowerInfoblox/_build/results?buildId=latest"><img src="https://img.shields.io/azure-devops/build/evotecpl/39c74615-8f34-4af0-a835-68dc33f9214f/14?label=Azure%20Pipelines&style=flat-square"></a> -->
  <a href="https://www.powershellgallery.com/packages/PowerInfoblox"><img src="https://img.shields.io/powershellgallery/v/PowerInfoblox.svg?style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/PowerInfoblox"><img src="https://img.shields.io/powershellgallery/vpre/PowerInfoblox.svg?label=powershell%20gallery%20preview&colorB=yellow&style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PowerInfoblox"><img src="https://img.shields.io/github/license/EvotecIT/PowerInfoblox.svg?style=flat-square"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PowerInfoblox"><img src="https://img.shields.io/powershellgallery/p/PowerInfoblox.svg?style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PowerInfoblox"><img src="https://img.shields.io/github/languages/top/evotecit/PowerInfoblox.svg?style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PowerInfoblox"><img src="https://img.shields.io/github/languages/code-size/evotecit/PowerInfoblox.svg?style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/PowerInfoblox"><img src="https://img.shields.io/powershellgallery/dt/PowerInfoblox.svg?style=flat-square"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=flat-square&logo=twitter"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg?style=flat-square"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn&style=flat-square"></a>
</p>

`PowerInfoblox` is a PowerShell module to interact with Infoblox service.
It's recommended to use this module in PowerShell 7, but it works in Windows PowerShell 5.1 as well.
The module is based on REST API and it's using `Invoke-RestMethod` to interact with Infoblox service.
This means error handling in PowerShell 7 is much better than in Windows PowerShell 5.1,
which means the errors provided are less generic and more specific.

### Installation

```powershell
Install-Module -Name PowerInfoblox -Force -Verbose
```

### Available commands

This module provides several commands to interact with Infoblox service.

| CommandType | Name                                      | Version | Source        |
| ----------- | ----------------------------------------- | ------- | ------------- |
| Alias       | Add-InfobloxSubnet                        | 1.0.30  | PowerInfoblox |
| Alias       | Get-InfobloxDHCPLeases                    | 1.0.30  | PowerInfoblox |
| Alias       | Get-InfobloxDNSAuthZones                  | 1.0.30  | PowerInfoblox |
| Alias       | Get-InfobloxDNSRecords                    | 1.0.30  | PowerInfoblox |
| Alias       | Get-InfobloxDNSRecordsAll                 | 1.0.30  | PowerInfoblox |
| Function    | Add-InfobloxDHCPRange                     | 1.0.30  | PowerInfoblox |
| Function    | Add-InfobloxDHCPRangeOptions              | 1.0.30  | PowerInfoblox |
| Function    | Add-InfobloxDHCPReservation               | 1.0.30  | PowerInfoblox |
| Function    | Add-InfoBloxDNSRecord                     | 1.0.30  | PowerInfoblox |
| Function    | Add-InfobloxFixedAddress                  | 1.0.30  | PowerInfoblox |
| Function    | Add-InfobloxNetwork                       | 1.0.30  | PowerInfoblox |
| Function    | Add-InfobloxNetworkExtensibleAttribute    | 1.0.30  | PowerInfoblox |
| Function    | Connect-Infoblox                          | 1.0.30  | PowerInfoblox |
| Function    | Disconnect-Infoblox                       | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDHCPLease                     | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDHCPRange                     | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDiscoveryTask                 | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDNSAuthZone                   | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDNSDelegatedZone              | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDNSForwardZone                | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDNSRecord                     | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDNSRecordAll                  | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxDNSView                       | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxFixedAddress                  | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxGrid                          | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxIPAddress                     | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxMember                        | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxNetwork                       | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxNetworkContainer              | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxNetworkNextAvailableIP        | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxNetworkNextAvailableNetwork   | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxNetworkView                   | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxObjects                       | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxPermission                    | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxResponsePolicyZones           | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxSchema                        | 1.0.30  | PowerInfoblox |
| Function    | Get-InfoBloxSearch                        | 1.0.30  | PowerInfoblox |
| Function    | Get-InfobloxVDiscoveryTask                | 1.0.30  | PowerInfoblox |
| Function    | Invoke-InfobloxQuery                      | 1.0.30  | PowerInfoblox |
| Function    | New-InfobloxOption                        | 1.0.30  | PowerInfoblox |
| Function    | Remove-InfobloxDHCPRangeOptions           | 1.0.30  | PowerInfoblox |
| Function    | Remove-InfobloxDnsRecord                  | 1.0.30  | PowerInfoblox |
| Function    | Remove-InfobloxFixedAddress               | 1.0.30  | PowerInfoblox |
| Function    | Remove-InfobloxIPAddress                  | 1.0.30  | PowerInfoblox |
| Function    | Remove-InfobloxNetworkExtensibleAttribute | 1.0.30  | PowerInfoblox |
| Function    | Remove-InfobloxObject                     | 1.0.30  | PowerInfoblox |
| Function    | Set-InfobloxDHCPRange                     | 1.0.30  | PowerInfoblox |
| Function    | Set-InfobloxDHCPRangeOptions              | 1.0.30  | PowerInfoblox |
| Function    | Set-InfobloxDNSRecord                     | 1.0.30  | PowerInfoblox |

### Examples

#### Connecting to Infoblox

Connect to Infoblox using your credentials.

```powershell
Connect-Infoblox -Server 'ipam.example.com' -ApiVersion '2.12' -EnableTLS12 -Credential (Get-Credential)
```

```powershell
$Username = '<your username>'
# Encrypted password
$SecurePassword = "01000000d08c9ddf0115d1118c7a00c04fc297eb01000000f41e4fd426443e4db66871df"
Connect-Infoblox -Server 'ipam.example.com' -Username $UserName -EncryptedPassword $SecurePassword -ApiVersion '2.12' -EnableTLS12
```

#### Examples of usage

Different examples of usage.

```powershell
Add-InfobloxFixedAddress -IPv4Address '10.2.2.18' -MacAddress '00:50:56:9A:00:01' -Verbose

Get-InfobloxSchema | Format-List *

Get-InfobloxSchema -Object 'record:host' | Format-List *

# only readable fields
(Get-InfobloxSchema -Object 'zone_auth').fields | Where-Object { $_.Supports -like "*r*" } | Select-Object Name

# only readable fields
(Get-InfobloxSchema -Object 'zone_auth').fields | Where-Object { $_.Supports -like "*r*" } | Format-Table

Get-InfobloxIPAddress -Network '10.2.2.0/24' -Status Used -Verbose | Format-Table

Get-InfobloxIPAddress -IPv4Address '10.2.2.18' -Verbose

Add-InfobloxFixedAddress -IPv4Address '10.2.2.18' -MacAddress '00:50:56:9A:00:01' -Verbose

Get-InfobloxFixedAddress -MacAddress '00:50:56:9A:00:01' -Verbose

Get-InfobloxIPAddress -IPv4Address '10.2.2.18' -Verbose

Get-InfobloxIPAddress -Network '10.2.2.0/24' -Status Used -Verbose | Format-Table

Remove-InfobloxFixedAddress -MacAddress '00:50:56:9A:00:01' -Verbose

# this should fail
Remove-InfobloxFixedAddress -MacAddress '00:50:56:9A:00:01' -IPv4Address '10.2.2.18' -Verbose

Get-InfobloxIPAddress -Network '10.2.2.0/24' -Status Used -Verbose | Format-Table

Get-InfobloxIPAddress -Network '10.2.2.0' -Status Used | Format-Table

$Network = Get-InfobloxNetwork -Network '10.2.2.0/24' -Verbose
$Network | Format-Table *

$Networks = Get-InfobloxNetwork -All -Verbose
$Networks | Format-Table *

Get-InfobloxNetworkNextAvailableIP -Network '10.2.2.0' -Quantity 5 -Verbose

#Get-InfobloxMember -Verbose | Format-Table

Get-InfobloxDNSRecords -Verbose -Type Host -Fetch | Format-Table *
Get-InfobloxDNSRecords -Verbose -Type PTR | Format-Table *
Get-InfobloxDNSRecords -Verbose -Type A | Format-Table *
Get-InfobloxDNSRecords -Verbose -Type CNAME | Format-Table *

$Schema = Get-InfobloxSchema -Object 'record:ptr' -Verbose
$Schema.fields.name -join ',' | Format-Table

Get-InfobloxDNSRecords -Verbose -Type Host | Select-Object -First 2 | Format-List *

$PTR = Get-InfobloxDNSRecords -Verbose -Type PTR -FetchFromSchema | Select-Object -First 200
$PTR | Format-Table

Get-InfobloxDNSRecords -Verbose -Type PTR -FetchFromSchema -Name '201.96.2.10.in-addr.arpa'

Get-InfobloxDNSRecords -Verbose -Type PTR -FetchFromSchema | Select-Object -First 200 | Format-Table Name, IPV4Addr, ptrdname, zone, _ref
Get-InfobloxDNSRecords -Verbose -Type CNAME | Select-Object -First 30 | Format-Table *


Get-InfobloxDNSRecords -Name 'example.test.lab' -Type CNAME -Verbose
Get-InfobloxDNSRecords -Name 'testhost11' -Type Host -Verbose

Get-InfobloxDNSRecords -Verbose -Type PTR -FetchFromSchema | Select-Object -First 200 | Format-Table Name, IPV4Addr, ptrdname, zone, _ref

Get-InfobloxDNSAuthZones | Format-Table

Get-InfobloxDNSAuthZones -FQDN '10.39.6.0/24' | Format-List

Get-InfobloxDNSForwardZone | Format-Table
Get-InfobloxDNSDelegatedZone | Format-Table
Get-InfobloxIPAddress -Network '10.2.33.0/24' -Status Unused | Format-Table
Add-InfoBloxDNSRecord -Type A -Name 'test132.example.lab' -IPv4Address 10.2.33.240 -Verbose
Add-InfoBloxDNSRecord -Type CNAME -Name 'test123.example.lab' -CanonicalName 'mcdonalds.pl'
```

#### Example of adding Network

```powershell
$addInfobloxSubnetSplat = @{
    Subnet                      = '10.22.35.0/24'
    Comment                     = "Oki dokii"
    AutoCreateReverseZone       = $true
    DHCPGateway                 = "10.22.35.1"
    DHCPLeaseTime               = 5000
    DHCPDomainNameServers       = "192.168.4.56,192.168.4.57"
    ExtensibleAttributeCountry = "Poland"
    #ExtensibleAttributeName    = "Test"
    ExtensibleAttributeRegion  = "Europe"
    ExtensibleAttributeSite    = "Site1"
    ExtensibleAttributeState   = "Mazowieckie"
    ExtensibleAttributeVLAN    = "810"
}

Add-InfobloxNetwork @addInfobloxSubnetSplat


$addInfobloxSubnetSplat = @{
    Subnet                = '10.22.36.0/24'
    Comment               = "Oki dokii"
    AutoCreateReverseZone = $true
    DHCPGateway           = "10.22.36.1"
    DHCPLeaseTime         = 5000
    DHCPDomainNameServers = "192.168.4.56,192.168.4.57"
    ExtensibleAttribute  = [ordered] @{
        #Name    = 'Test'
        VLAN    = '810'
        Country = 'Poland'
        Region  = 'Europe'
        Site    = 'Site1'
    }
}

Add-InfobloxNetwork @addInfobloxSubnetSplat

$addInfobloxSubnetSplat = @{
    Subnet               = '10.22.37.0/24'
    Comment              = 'List EA example'
    ExtensibleAttribute = [ordered] @{
        NetworkType     = 'on-prem SDC'
        'Support group' = @('Tier1', 'Tier2')
    }
}

Add-InfobloxNetwork @addInfobloxSubnetSplat

Remove-InfobloxNetworkExtensibleAttribute -Network '10.22.36.0/24' -Attribute 'VLAN'
Add-InfobloxNetworkExtensibleAttribute -Network '10.22.36.0/24' -Attribute 'VLAN' -Value '811'
```

#### Example of adding DHCP Range

```powershell
$addInfobloxSubnetSplat = @{
    Subnet                = '10.22.41.0/24'
    Comment               = "Oki dokii"
    AutoCreateReverseZone = $true
    DHCPGateway           = "10.22.41.1"
    DHCPLeaseTime         = 5000
    DHCPDomainNameServers = "192.168.4.56,192.168.4.57"
    ExtensibleAttribute  = [ordered] @{
        #Name    = 'Test'
        VLAN    = '810'
        Country = 'Poland'
        Region  = 'Europe'
        Site    = 'Site1'
    }
    Members               = @(
        'dhcp2016.evotec.pl'
    )
}

Add-InfobloxNetwork @addInfobloxSubnetSplat

Add-InfobloxDHCPRange -StartAddress '10.22.41.15' -EndAddress '10.22.41.30'

$addInfobloxDHCPRangeSplat = @{
    StartAddress          = '10.22.41.70'
    EndAddress            = '10.22.41.90'
    Verbose               = $true
    MSServer              = 'dhcp2016.evotec.pl'
    Name                  = 'DHCP Range Me2?'
    ServerAssociationType = 'MS_SERVER'
    Exclude               = '10.22.41.75-10.22.41.79'
}

Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat
```
