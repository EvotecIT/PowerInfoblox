---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxDNSZone
## SYNOPSIS
Creates an authoritative, forward, or delegated DNS zone.

## SYNTAX
### __AllParameterSets
```powershell
Add-InfobloxDNSZone [-Type] <string> [-Name] <string> [[-View] <string>] [[-Properties] <IDictionary>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a zone_auth, zone_forward, or zone_delegated WAPI object. Name becomes the
fqdn field. Supply the remaining WAPI fields in Properties, such as grid_primary,
forward_to, or delegate_to, according to the connected Grid's schema.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxDNSZone -Type Authoritative -Name 'example.com' -View Internal -WhatIf
```

Previews creating an authoritative zone in the Internal view.

## PARAMETERS

### -Name
The zone's fully qualified domain name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Additional WAPI fields needed for the zone kind and Grid configuration.

```yaml
Type: IDictionary
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The zone kind: Authoritative, Forward, or Delegated.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values: Authoritative, Forward, Delegated

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS view. When omitted, WAPI chooses its default.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
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
