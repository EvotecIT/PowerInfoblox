---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxIPAddress
## SYNOPSIS
Removes an IP address from Infoblox.

## SYNTAX
### __AllParameterSets
```powershell
Remove-InfobloxIPAddress [[-IPv4Address] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function removes an IP address from Infoblox. It checks for an existing connection to an Infoblox server, established via Connect-Infoblox, before attempting the removal. The function supports verbose output for detailed operation insights.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxIPAddress -IPv4Address '192.168.1.100'
Removes the IP address 192.168.1.100 from Infoblox.
```


## PARAMETERS

### -IPv4Address
The IPv4 address to be removed from Infoblox. This parameter is mandatory.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
