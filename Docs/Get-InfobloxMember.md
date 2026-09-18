---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxMember
## SYNOPSIS
Retrieves Infoblox Grid members.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxMember [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI member objects. By default, the command requests a
curated set of identity, platform, network, and service-status properties.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxMember
```

Returns Grid members using the preferred field set.

### EXAMPLE 2
```powershell
PS > Get-InfobloxMember -FetchFromSchema
```

Returns Grid members with all fields advertised by the connected WAPI schema.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the member object by the connected WAPI schema.

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
