---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxFixedAddress
## SYNOPSIS
Retrieves fixed IPv4 address assignments by MAC address.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxFixedAddress [-MacAddress] <string> [[-Properties] <string[]>] [-PartialMatch] [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI fixedaddress objects for an exact or partial MAC address
match. By default, the result includes the MAC address, IPv4 address, network
view, and object reference.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxFixedAddress -MacAddress '00:11:22:33:44:55'
```

Returns fixed address assignments for the exact MAC address.

### EXAMPLE 2
```powershell
PS > Get-InfobloxFixedAddress -MacAddress '00:11:22' -PartialMatch -Properties mac,ipv4addr,comment
```

Returns partially matching assignments and limits the returned fields.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the fixedaddress object by the connected WAPI schema.

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

### -MacAddress
Specifies the MAC address to find.

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

### -PartialMatch
Uses partial matching instead of an exact MAC address match.

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

### -Properties
Specifies the fixedaddress fields to return instead of the default fields.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 1
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
