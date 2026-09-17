---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxFixedAddress
## SYNOPSIS
Add a fixed mac address to an IP address on an Infoblox server

## SYNTAX
### __AllParameterSets
```powershell
Add-InfobloxFixedAddress [-IPv4Address] <string> [-MacAddress] <string> [[-Name] <string>] [[-Comment] <string>] [[-MicrosoftServer] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add a fixed mac address to an IP address on an Infoblox server
A fixed address is a specific IP address that a DHCP server always assigns when a lease request comes from
a particular MAC address of the client. For example, if you have a printer in your network, you can reserve a
particular IP address to be assigned to it every time it is turned on.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxFixedAddress -IPv4Address '10.2.2.18' -MacAddress '00:50:56:9A:00:01'
```


## PARAMETERS

### -Comment
Comment for the fixed address

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPv4Address
IPv4 address to add the mac address to

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

### -MacAddress
Mac address to add to the IPv4 address

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

### -MicrosoftServer
IPv4 address or FQDN of the Microsoft DHCP server to use for the fixed address.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ms_server
Possible values:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the fixed address

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
