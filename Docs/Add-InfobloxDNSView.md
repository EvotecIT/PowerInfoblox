---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxDNSView
## SYNOPSIS
Creates a DNS view.

## SYNTAX
### __AllParameterSets
```powershell
Add-InfobloxDNSView [-Name] <string> [[-NetworkView] <string>] [[-Properties] <IDictionary>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a WAPI view object. Name identifies the view. Supply optional Grid-specific
fields through Properties.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxDNSView -Name Internal -NetworkView default -WhatIf
```

Previews creating a DNS view named Internal.

## PARAMETERS

### -Name
The name of the new DNS view.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkView
The network view to associate with the DNS view.

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

### -Properties
Additional WAPI view fields.

```yaml
Type: IDictionary
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
