---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDNSAuthZone
## SYNOPSIS
Retrieves authoritative DNS zones from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxDNSAuthZone [[-FQDN] <string>] [[-View] <string>] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI zone_auth objects. Results can be filtered by fully
qualified domain name and DNS view.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDNSAuthZone -FQDN 'example.com' -View 'default'
```

Returns the example.com authoritative zone from the default DNS view.

### EXAMPLE 2
```powershell
PS > Get-InfobloxDNSAuthZones -View 'default'
```

Uses the plural compatibility alias to return authoritative zones from the default view.

## PARAMETERS

### -FQDN
Filters authoritative zones by fully qualified domain name.

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
Filters authoritative zones by DNS view name.

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
