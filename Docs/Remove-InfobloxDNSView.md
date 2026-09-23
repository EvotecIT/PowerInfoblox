---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxDNSView
## SYNOPSIS
Removes one DNS view.

## SYNTAX
### ByName (Default)
```powershell
Remove-InfobloxDNSView -Name <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByReference
```powershell
Remove-InfobloxDNSView -ReferenceID <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Selects one view by Name or exact WAPI ReferenceID. Ambiguous or mismatched
lookups list available references and skip removal. The default view cannot
be removed.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxDNSView -Name Internal -WhatIf
```

Previews removing the Internal view.

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
