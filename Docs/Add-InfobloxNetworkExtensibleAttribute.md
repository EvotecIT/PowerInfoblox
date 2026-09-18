---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxNetworkExtensibleAttribute
## SYNOPSIS
Adds an extensible attribute to a specified network in Infoblox.

## SYNTAX
### __AllParameterSets
```powershell
Add-InfobloxNetworkExtensibleAttribute [-Network] <string> [-Attribute] <string> [-Value] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function adds an extensible attribute to a network in Infoblox.
It requires an established connection to an Infoblox server, which can be done using the Connect-Infoblox function.
The function checks if the specified network exists before attempting to add the extensible attribute.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxNetworkExtensibleAttribute -Network '192.168.1.0/24' -Attribute 'Location' -Value 'Data Center 1'
Adds the 'Location' extensible attribute with the value 'Data Center 1' to the network '192.168.1.0/24'.
```


## PARAMETERS

### -Attribute
The name of the extensible attribute to add. This parameter is mandatory.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensinbleAttribute, ExtensibleAttribute
Possible values:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
The network to which the extensible attribute will be added. This parameter is mandatory.

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

### -Value
The value of the extensible attribute to add. This parameter is mandatory.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensinbleAttributeValue, ExtensibleAttributeValue
Possible values:

Required: True
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
