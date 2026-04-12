---
title: "Find next available network"
description: "Use PowerInfoblox to ask Infoblox for available child networks."
layout: docs
---

This pattern is useful when a script needs Infoblox to suggest available network space.

It is adapted from `Examples/Package/ExampleToPackageContainer.ps1`.

## Example

```powershell
Import-Module PowerInfoblox

$credential = Get-Credential
Connect-Infoblox -Server 'ipam.example.com' -Credential $credential -ApiVersion '2.13.1' -EnableTLS12

Get-InfobloxNetworkContainer -Network '198.51.100.0/24' -Verbose | Format-Table
Get-InfobloxNetworkNextAvailableNetwork -Network '198.51.100.0/24' -Quantity 5 -Cidr 28 -Verbose | Format-Table

Disconnect-Infoblox
```

## What this demonstrates

- checking a network container
- asking for candidate child networks
- keeping credentials and IPAM endpoints out of the public example

## Source

- [ExampleToPackageContainer.ps1](https://github.com/EvotecIT/PowerInfoblox/blob/master/Examples/Package/ExampleToPackageContainer.ps1)
