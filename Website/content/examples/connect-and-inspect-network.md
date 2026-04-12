---
title: "Connect and inspect a network"
description: "Use PowerInfoblox to connect to Infoblox and inspect a selected network."
layout: docs
---

This pattern is useful when you need to confirm API access and inspect a network before making changes.

It is adapted from `Examples/Package/ExampleProd.ps1`.

## Example

```powershell
Import-Module PowerInfoblox

$credential = Get-Credential
Connect-Infoblox -Server 'ipam.example.com' -Credential $credential -ApiVersion '2.13.1' -EnableTLS12

$network = Get-InfobloxNetwork -Network '192.0.2.0/24' -Verbose
$network | Format-Table *

Get-InfobloxIPAddress -Network '192.0.2.0/24' -Status Used -Verbose | Format-Table

Disconnect-Infoblox
```

## What this demonstrates

- connecting with an interactive credential
- querying a selected network
- reviewing used IP addresses before changing anything

## Source

- [ExampleProd.ps1](https://github.com/EvotecIT/PowerInfoblox/blob/master/Examples/Package/ExampleProd.ps1)
