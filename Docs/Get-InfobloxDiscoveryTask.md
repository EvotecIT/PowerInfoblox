---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDiscoveryTask
## SYNOPSIS
Retrieves discovery tasks from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxDiscoveryTask [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI discoverytask objects and returns their properties with
the object reference placed last.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDiscoveryTask
```

Returns discovery tasks using the default WAPI fields.

### EXAMPLE 2
```powershell
PS > Get-InfobloxDiscoveryTask -FetchFromSchema
```

Returns discovery tasks with all fields advertised by the connected WAPI schema.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the discoverytask object by the connected WAPI schema.

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
