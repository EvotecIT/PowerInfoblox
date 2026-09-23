---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Set-InfobloxDNSZone
## SYNOPSIS
Updates an authoritative, forward, delegated, response policy, or stub DNS zone.

## SYNTAX
### ByName (Default)
```powershell
Set-InfobloxDNSZone -Type <string> -Name <string> -Properties <IDictionary> [-View <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByReference
```powershell
Set-InfobloxDNSZone -ReferenceID <string> -Properties <IDictionary> [-Type <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates one zone selected by its WAPI ReferenceID or by Type, Name, and optional
View. Ambiguous or mismatched lookups list available references and skip the update.
Supply the WAPI fields to change in Properties.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Set-InfobloxDNSZone -Type Authoritative -Name example.com -View Internal -Properties @{ comment = 'Managed zone' } -WhatIf
```

Previews changing a zone after finding its exact reference.

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

### -Properties
Nonempty WAPI field dictionary to update.

```yaml
Type: IDictionary
Parameter Sets: ByName, ByReference
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
The exact WAPI zone reference.

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
Authoritative, Forward, Delegated, ResponsePolicy, or Stub. Required when selecting by Name.

```yaml
Type: String
Parameter Sets: ByName, ByReference
Aliases: None
Possible values: Authoritative, Forward, Delegated, ResponsePolicy, Stub

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
