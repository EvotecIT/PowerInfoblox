# PowerInfoblox

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PowerInfoblox.svg?style=flat-square)](https://www.powershellgallery.com/packages/PowerInfoblox)
[![PowerShell Gallery downloads](https://img.shields.io/powershellgallery/dt/PowerInfoblox.svg?style=flat-square)](https://www.powershellgallery.com/packages/PowerInfoblox)
[![Test PowerShell](https://github.com/EvotecIT/PowerInfoblox/actions/workflows/test-powershell-module.yml/badge.svg)](https://github.com/EvotecIT/PowerInfoblox/actions/workflows/test-powershell-module.yml)

PowerInfoblox is a PowerShell module for working with Infoblox NIOS through the Web API (WAPI). It covers common IPAM, network, DHCP, DNS, Grid, discovery, and schema operations.

The module supports PowerShell 7 and Windows PowerShell 5.1. PowerShell 7 is recommended because REST API errors usually contain more useful response details.

## Installation

Install PowerInfoblox from the PowerShell Gallery:

```powershell
Install-Module -Name PowerInfoblox -Scope CurrentUser
```

Update an existing installation with:

```powershell
Update-Module -Name PowerInfoblox
```

## Connect to a Grid

Set `ApiVersion` to a WAPI version supported by the target Grid:

```powershell
$credential = Get-Credential

Connect-Infoblox `
    -Server 'grid.example.com' `
    -ApiVersion '2.14' `
    -Credential $credential
```

The default request timeout is 600 seconds. Use `TimeoutSec` when an environment needs more time:

```powershell
Connect-Infoblox `
    -Server 'grid.example.com' `
    -ApiVersion '2.14' `
    -Credential $credential `
    -TimeoutSec 1800
```

Call `Disconnect-Infoblox` when the connection context is no longer needed. This clears credentials, session defaults, and cached schema information from the module session.

## Queries across WAPI versions

Infoblox Grids can expose different readable fields depending on their WAPI version and configuration. PowerInfoblox checks the connected endpoint schema before requesting optional fields from network, DNS, DHCP, Grid, and member objects. For example, `vlans` is requested when the network schema marks it as readable and omitted when it is unavailable.

Schema results are cached per endpoint, object type, and operation. If schema discovery is unavailable, the request omits `_return_fields` and uses the server's default fields. Commands that support `FetchFromSchema` can still request every field marked readable by the connected Grid. Explicit field parameters, such as `ReturnFields` or `Properties`, remain under the caller's control.

```powershell
# Get one network with the module's normalized output
$network = Get-InfobloxNetwork -Network '10.20.30.0/24'

# Find matching networks
Get-InfobloxNetwork -Network '10.20.' -Partial

# Return all networks, up to the requested limit
Get-InfobloxNetwork -All -MaxResults 500

# Ask for every field marked readable by the connected Grid schema
Get-InfobloxNetwork -Network '10.20.30.0/24' -FetchFromSchema

# Request an explicit field set and keep the native WAPI response
Get-InfobloxNetwork `
    -Network '10.20.30.0/24' `
    -ReturnFields 'network', 'comment', 'vlans' `
    -Native

# Request selected lease fields explicitly
Get-InfobloxDHCPLease `
    -Network '10.20.30.0/24' `
    -ReturnFields 'address', 'binding_state', 'client_hostname'
```

Use `Get-InfobloxSchema` to inspect the capabilities exposed by the connected endpoint:

```powershell
Get-InfobloxSchema -Object 'network'
Get-InfobloxSchema -Object 'network' -ReturnReadOnlyFields
Get-InfobloxSchema -Object 'network' -ReturnWriteFields
```

## Common workflows

### IP addresses and fixed addresses

```powershell
# Used addresses in a network
Get-InfobloxIPAddress -Network '10.20.30.0/24' -Status Used

# A specific address
Get-InfobloxIPAddress -IPv4Address '10.20.30.25'

# Ask Infoblox for the next available addresses
Get-InfobloxNetworkNextAvailableIP -Network '10.20.30.0/24' -Quantity 3

# Create, inspect, and remove a fixed address
Add-InfobloxFixedAddress `
    -IPv4Address '10.20.30.25' `
    -MacAddress '00:50:56:9A:00:01' `
    -Name 'printer-01'

Get-InfobloxFixedAddress -MacAddress '00:50:56:9A:00:01'

Remove-InfobloxFixedAddress `
    -MacAddress '00:50:56:9A:00:01' `
    -IPv4Address '10.20.30.25'
```

### Networks and extensible attributes

```powershell
$networkParameters = @{
    Network             = '10.20.40.0/24'
    Comment             = 'Application network'
    AutoCreateReverseZone = $true
    DHCPGateway         = '10.20.40.1'
    DHCPLeaseTime       = 86400
    DHCPDomainNameServers = '10.20.1.10,10.20.1.11'
    ExtensibleAttribute = [ordered] @{
        Country     = 'Poland'
        Region      = 'Europe'
        NetworkType = 'Application'
    }
}

Add-InfobloxNetwork @networkParameters

Add-InfobloxNetworkExtensibleAttribute `
    -Network '10.20.40.0/24' `
    -Attribute 'VLAN' `
    -Value '810'

Remove-InfobloxNetworkExtensibleAttribute `
    -Network '10.20.40.0/24' `
    -Attribute 'VLAN'
```

List and enum extensible attributes can use the display values shown in the Infoblox UI. PowerInfoblox resolves those values to the internal IDs used by WAPI.

### Network DHCP members

Replace, add, remove, or clear the member list associated with a network:

```powershell
Set-InfobloxNetworkMembers `
    -Network '10.20.40.0/24' `
    -Members 'dhcp01.example.com', 'dhcp02.example.com'

Set-InfobloxNetworkMembers `
    -Network '10.20.40.0/24' `
    -AddMembers 'dhcp03.example.com'

Set-InfobloxNetworkMembers `
    -Network '10.20.40.0/24' `
    -RemoveMembers 'dhcp01.example.com'

Set-InfobloxNetworkMembers -Network '10.20.40.0/24' -Members @()
```

The default member structure is `msdhcpserver`. Use `MemberStruct` and `MemberProperty` for another WAPI member structure.

Replacing the complete list with `Members` only requires the network reference. `AddMembers` and `RemoveMembers` first read the current list; if the connected Grid does not expose `network.members` as readable, PowerInfoblox stops without writing rather than risk replacing an unknown configuration.

### DHCP ranges

```powershell
Add-InfobloxDHCPRange `
    -StartAddress '10.20.40.50' `
    -EndAddress '10.20.40.150' `
    -Name 'Application clients' `
    -MSServer 'dhcp01.example.com' `
    -ServerAssociationType 'MS_SERVER' `
    -Exclude '10.20.40.100-10.20.40.110'
```

Use `Add-InfobloxDHCPRangeOptions`, `Set-InfobloxDHCPRangeOptions`, and `Remove-InfobloxDHCPRangeOptions` to manage DHCP options on an existing range.

### DNS records

```powershell
# Query records
Get-InfobloxDNSRecord -Type A -Zone 'example.com'
Get-InfobloxDNSRecord -Type Host -Name 'server01.example.com'

# Create records
Add-InfoBloxDNSRecord `
    -Type A `
    -Name 'server01.example.com' `
    -IPAddress '10.20.30.25'

Add-InfoBloxDNSRecord `
    -Type CNAME `
    -Name 'app.example.com' `
    -CanonicalName 'server01.example.com'
```

## Discover commands

List the commands exported by the installed version:

```powershell
Get-Command -Module PowerInfoblox
```

Use PowerShell help for command syntax and examples:

```powershell
Get-Help Connect-Infoblox -Full
Get-Help Get-InfobloxNetwork -Examples
Get-Help Add-InfobloxDHCPRange -Full
```

## Releases and support

Release notes are maintained in [GitHub Releases](https://github.com/EvotecIT/PowerInfoblox/releases). Use [GitHub Issues](https://github.com/EvotecIT/PowerInfoblox/issues) for reproducible bugs and feature requests.
