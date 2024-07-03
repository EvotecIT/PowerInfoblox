### 1.0.24 - 2024.07.03
- Added `Debug` option to show JSON body
- Added `WhatIf` to `Add-InfobloxDHCPRange`

### 1.0.23 - 2024.06.19
- Add MSOptions to Add-InfobloxDHCPrange and `Add-InfobloxNetwork` to be able to set Microsoft DHCP options
- Expanded `New-InfobloxOption` with Type and UserClass parameters

### 1.0.22 - 2024.06.13
- Improve `Get-InfobloxFixedAddress` by adding `FetchFromSchema`
- Improve `Add-InfobloxFixedAddress` by adding `MicrosoftServer` ()`ms_server`) property

### 1.0.21 - 2024.05.29
- Add `Options` to `Add-InfobloxDHCPRange` to be able to set DHCP options
- Add `Options` to `Add-InfobloxNetwork` to be able to set DHCP options
- Add `New-InfoBloxOption` to prepare options to be used in `Add-InfobloxDHCPRange` and `Add-InfobloxNetwork`

```powershell
$addInfobloxDHCPRangeSplat = @{
    StartAddress = '10.10.12.5'
    EndAddress   = '10.10.12.10'
    Options      = @(
        New-InfobloxOption -Name "dhcp-lease-time" -Number 51 -UseOption -Value '86400' -VendorClass 'DHCP'
        New-InfobloxOption -Name "domain-name-servers" -Number 6 -UseOption -Value '192.168.0.15' -VendorClass 'DHCP'
        New-InfobloxOption -Name 'routers' -Number 3 -UseOption -Value '192.168.11.12' -VendorClass 'DHCP'
        New-InfobloxOption -Name 'time-servers' -Number 4 -UseOption -Value '11' -VendorClass 'DHCP'
    )
    Verbose      = $true
}

Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat
```


### 1.0.20 - 2024.05.22
- Improve `Get-InfobloxNetwork` by adding `Members` to be able to set DHCP range properly
- Improve `Get-InfobloxDHCPRange` with docs, examples and fixes

### 1.0.19 - 2024.05.22
- Fixes typo in `Add-InfobloxDHCPRange` function

### 1.0.18 - 2024.05.21
- Improve `Get-InfobloxNetwork` with `Native` parameter which allows to get native Infoblox objects without translation
- Improve `Get-InfobloxNetwork` with `MaxResults` parameter which allows to limit amount of results (default is 1000000)
- Improve `Get-InfobloxNetwork` with additional warning if no parameters given
- Improve `Get-InfobloxSchema` by adding `ReturnWriteFields`, `ReturnFields`
- Improve `Get-InfobloxDHCPRange` with `MaxResults` parameter which allows to limit amount of results (default is 1000000)
- Added `Add-InfobloxDHCPRange` to add a DHCP range

### 1.0.17 - 2024.05.10
- Fix `Connect-Infoblox` to make sure it is working with EncryptedPassword

### 1.0.16 - 2024.05.10
- Rename `Add-InfobloxSubnet` to `Add-InfobloxNetwork` to be consistent with other functions
- Improve `Add-InfobloxNetwork` to add more parameters around extension attributes
- Add `Remove-InfobloxNetworkExtensibleAttribute` to remove extensible attributes from a network
- Add `Add-InfobloxNetworkExtensibleAttribute` to add extensible attributes to a network

### 1.0.15 - 2024.05.08
- Add `Add-InfobloxSubnet` to add a subnet

### 1.0.14 - 2024.04.16
- Fixes `Get-InfobloxObjects`

### 1.0.13 - 2024.03.28
- Fixes `Remove-InfobloxDNSRecord` when it comes to PTR records

### 1.0.12 - 2024.03.28
- Improved `Remove-InfobloxDNSRecord` to hide some irrelevant verbose messages

### 1.0.11 - 2024.03.28
- Make sure `WhatIf` is disabled for all `Get` functions

### 1.0.10 - 2024.03.28
- Added `Remove-InfobloxDNSRecord` to remove multiple records including PTR
- Improved `Remove-InfobloxObject` with ReturnSuccess parameter
- Improved `Get-InfobloxObject` with additional parameters

### 1.0.9 - 2024.03.21
- Add error handling in PS 7 for better error messages

### 1.0.8 - 2024.03.21
- Skip certificate validation when connecting to Infoblox wasn't working on PowerShell 7.

### 1.0.7 - 2024.03.11
- Bettr handling `Connect-Infoblox` and `Disconnect-Infoblox` preferring WebSession (Cookies) over Login/Password

### 1.0.6 - 2024.03.08
- Improve `Add-InfobloxFixedAddress` by adding Comment, Name fields

### 1.0.5 - 2024.03.06
- Add `ErrorAction Stop` improvements to all functions to make sure that errors are handled properly if required
- Improve adding DNS records with `Add-InfobloxDNSRecord` - now it is possible to add `CNAME` and `PTR` records
- Improve handling of WhatIf which would show adding of record failed when using WhatIf
- Add `Set-InfobloxDNSRecord` to update DNS records

### 1.0.4 - 2024.03.05
- Improved `Get-InfobloxDNSRecord`- changes output slightly
- Improved `Get-InfobloxDNSRecordAll` - changes output slightly to make sure all records contain the same fields
- Improved `Add-InfobloxDNSRecord` adding ability to add HOST record

### 1.0.3 - 2024.02.14
- Added `Get-InfobloxDHCPLease`
- Added `Get-InfobloxDHCPRange`
- Added `Get-InfobloxDiscoveryTask`
- Added `Get-InfobloxVDiscoveryTask`
- Added `Get-InfobloxObjects`
- Added `Get-infobloxPermission`
- Added `Get-InfobloxResponsePolicyZones`
- Improve `Invoke-InfobloxQUery`
- Improve `Get-InfobloxNetwork`
- Improve `Get-InfobloxNetworkView`
- Improve `Get-InfobloxShema`

### 1.0.2 - 2024.01.18
- Added `Add-InfobloxDNSRecord`
- Added `Get-infobloxDNSDelegatedZone`
- Added `Get-InfobloxDNSForwardZone`
- Small improvements overall

### 1.0.1 - 2024.01.17
- Added `Get-InfobloxDNSRecordAll`
- Improved getting more records from Infoblox using single query
- Tested on version `2.9/2.12` of the API

### 1.0.0
- Initial release