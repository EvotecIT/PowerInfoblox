---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Set-InfobloxDNSView
## SYNOPSIS
Updates one DNS view.

## SYNTAX
### ByName (Default)
```powershell
Set-InfobloxDNSView -Name <string> -Properties <IDictionary> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByReference
```powershell
Set-InfobloxDNSView -ReferenceID <string> -Properties <IDictionary> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Selects one view by Name or exact WAPI ReferenceID. Ambiguous or mismatched
lookups list available references and skip the update.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Set-InfobloxDNSView -Name Internal -Properties @{ comment = 'Internal clients' } -WhatIf
```

Previews changing the view comment.

## PARAMETERS

### -Name
The existing DNS view name.

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
The exact WAPI view reference.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
