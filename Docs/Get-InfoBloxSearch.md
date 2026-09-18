---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfoBloxSearch
## SYNOPSIS
Searches Infoblox objects by IPv4 address.

## SYNTAX
### IPv4
```powershell
Get-InfoBloxSearch [-IPv4Address <string>] [<CommonParameters>]
```

## DESCRIPTION
Queries the Infoblox WAPI search endpoint. When IPv4Address is omitted, the
endpoint is queried without an address filter.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfoBloxSearch -IPv4Address '192.0.2.15'
```

Returns Infoblox search results associated with the specified address.

## PARAMETERS

### -IPv4Address
Filters search results by IPv4 address.

```yaml
Type: String
Parameter Sets: IPv4
Aliases: None
Possible values:

Required: False
Position: named
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
