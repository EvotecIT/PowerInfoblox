---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDNSDelegatedZone
## SYNOPSIS
Retrieves delegated DNS zones from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxDNSDelegatedZone [[-Name] <string>] [[-View] <string>] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI zone_delegated objects. Results can be filtered by zone
name and DNS view.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDNSDelegatedZone -Name 'delegated.example.com' -View 'default'
```

Returns the delegated zone from the default DNS view.

## PARAMETERS

### -Name
Filters delegated zones by fully qualified domain name.

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
Filters delegated zones by DNS view name.

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
