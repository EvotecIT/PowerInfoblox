---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxResponsePolicyZones
## SYNOPSIS
Retrieves response policy zones from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxResponsePolicyZones [[-FQDN] <string>] [[-View] <string>] [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI zone_rp objects available to the connected account.
Results can be filtered by zone FQDN and DNS view.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxResponsePolicyZones
```

Returns response policy zones using the default WAPI fields.

### EXAMPLE 2
```powershell
PS > Get-InfobloxResponsePolicyZones -FQDN example.com -View Internal -FetchFromSchema
```

Returns the matching response policy zone with all readable fields advertised by the connected WAPI schema.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the zone_rp object by the connected WAPI schema.

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

### -FQDN
Filters response policy zones by fully qualified domain name.

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

### -View
Filters response policy zones by DNS view name.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
