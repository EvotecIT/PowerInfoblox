---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxFixedAddress
## SYNOPSIS
Removes fixed IPv4 address assignments by MAC address.

## SYNTAX
### __AllParameterSets
```powershell
Remove-InfobloxFixedAddress [-MacAddress] <string> [[-IPv4Address] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Finds fixedaddress objects using an exact MAC address match and removes each
matching object. Specify IPv4Address to narrow removal to one address. The
command supports WhatIf and Confirm.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxFixedAddress -MacAddress '00:11:22:33:44:55' -IPv4Address '192.0.2.15' -WhatIf
```

Shows the fixed address assignment targeted by the command without requesting removal.

### EXAMPLE 2
```powershell
PS > Remove-InfobloxFixedAddress -MacAddress '00:11:22:33:44:55' -Confirm
```

Requests confirmation while removing all fixed assignments for the exact MAC address.

## PARAMETERS

### -IPv4Address
Limits removal to a fixed assignment with this IPv4 address.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacAddress
Specifies the exact MAC address whose fixed assignments should be removed.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
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
