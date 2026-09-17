---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxNetworkExtensibleAttribute
## SYNOPSIS
Removes an extensible attribute from a specified network in Infoblox.

## SYNTAX
### __AllParameterSets
```powershell
Remove-InfobloxNetworkExtensibleAttribute [-Network] <string> [-Attribute] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function removes an extensible attribute from a network in Infoblox.
It requires an established connection to an Infoblox server, which can be done using the Connect-Infoblox function.
The function checks if the specified network exists before attempting to remove the extensible attribute.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxNetworkExtensibleAttribute -Network '192.168.1.0/24' -Attribute 'Location'
Removes the 'Location' extensible attribute from the network '192.168.1.0/24'.
```


## PARAMETERS

### -Attribute
The name of the extensible attribute to remove. This parameter is mandatory.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttribute
Possible values:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
The network from which the extensible attribute will be removed. This parameter is mandatory.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: Subnet
Possible values:

Required: True
Position: 0
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
