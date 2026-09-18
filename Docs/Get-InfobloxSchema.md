---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxSchema
## SYNOPSIS
Get the schema for Infoblox as a whole or a specific object

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxSchema [[-Object] <string>] [-ReturnReadOnlyFields] [-ReturnWriteFields] [-ReturnFields] [<CommonParameters>]
```

## DESCRIPTION
Get the schema for Infoblox as a whole or a specific object

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxSchema
```


### EXAMPLE 2
```powershell
PS > Get-InfobloxSchema -Object 'record:host'
```


## PARAMETERS

### -Object
The object to get the schema for

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

### -ReturnFields
Return all fields in full objects

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

### -ReturnReadOnlyFields
Return only read-only fields in format suitable for use with Invoke-InfobloxQuery

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

### -ReturnWriteFields
Return only write fields in format suitable for use with Invoke-InfobloxQuery

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
