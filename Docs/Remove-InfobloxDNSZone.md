---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxDNSZone
## SYNOPSIS
Removes one authoritative, forward, or delegated DNS zone.

## SYNTAX
### ByName (Default)
```powershell
Remove-InfobloxDNSZone -Type <string> -Name <string> [-View <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByReference
```powershell
Remove-InfobloxDNSZone -ReferenceID <string> [-Type <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Selects one zone by exact WAPI ReferenceID or by Type, Name, and optional View.
Ambiguous or mismatched lookups list available references and skip removal.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxDNSZone -Type Forward -Name example.com -View Internal -WhatIf
```

Previews removing one forward zone.

## PARAMETERS

### -Name
The existing zone FQDN.

```yaml
Type: String
Parameter Sets: ByName
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
The exact zone_auth, zone_forward, or zone_delegated WAPI reference.

```yaml
Type: String
Parameter Sets: ByReference
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Authoritative, Forward, or Delegated. Required when selecting by Name.

```yaml
Type: String
Parameter Sets: ByName, ByReference
Aliases: None
Possible values: Authoritative, Forward, Delegated

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The existing DNS view used with Name.

```yaml
Type: String
Parameter Sets: ByName
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
