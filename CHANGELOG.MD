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