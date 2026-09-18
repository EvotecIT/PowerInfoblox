---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxNetworkView
## SYNOPSIS
Retrieves network views from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxNetworkView [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI networkview objects and returns the network views available
to the current connection.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxNetworkView
```

Returns network views using the default WAPI fields.

### EXAMPLE 2
```powershell
PS > Get-InfobloxNetworkView -FetchFromSchema
```

Returns network views with all fields advertised by the connected WAPI schema.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the networkview object by the connected WAPI schema.

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
