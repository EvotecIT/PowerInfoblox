---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDNSStubZone
## SYNOPSIS
Retrieves DNS stub zones.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxDNSStubZone [[-FQDN] <string>] [[-View] <string>] [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI zone_stub objects. Results can be filtered by zone
FQDN and DNS view.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDNSStubZone -FQDN example.com -View Internal
```

Returns the stub zone and its WAPI reference.

## PARAMETERS

### -FetchFromSchema
Requests every readable zone_stub field advertised by the connected WAPI schema.

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
Filters stub zones by fully qualified domain name.

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
Filters stub zones by DNS view name.

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
