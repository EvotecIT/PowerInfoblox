---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxGrid
## SYNOPSIS
Retrieves Infoblox Grid configuration.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxGrid [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries the Infoblox WAPI grid object. By default, the command requests a
curated set of commonly useful Grid properties supported by the connected schema.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxGrid
```

Returns Grid configuration using the preferred field set.

### EXAMPLE 2
```powershell
PS > Get-InfobloxGrid -FetchFromSchema
```

Returns Grid configuration with all fields advertised by the connected WAPI schema.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the grid object by the connected WAPI schema.

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
