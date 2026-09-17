---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Disconnect-Infoblox
## SYNOPSIS
Disconnects from an InfoBlox server

## SYNTAX
### __AllParameterSets
```powershell
Disconnect-Infoblox [-ForceLogOut] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Disconnects from an InfoBlox server
As this is a REST API it doesn't really disconnect, but it does clear the script variable to clear the credentials from memory

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Disconnect-Infoblox
```


## PARAMETERS

### -ForceLogOut
Sends a WAPI logout request before clearing the local connection state.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
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
