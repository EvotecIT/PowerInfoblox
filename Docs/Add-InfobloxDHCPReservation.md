---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxDHCPReservation
## SYNOPSIS
Add a DHCP reservation to an Infoblox server

## SYNTAX
### __AllParameterSets
```powershell
Add-InfobloxDHCPReservation [-IPv4Address] <string> [-MacAddress] <string> [-Name] <string> [-Network] <string> [[-Comment] <string>] [[-MicrosoftServer] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add a DHCP reservation to an Infoblox server

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxDHCPReservation -IPv4Address '10.2.2.18' -MacAddress '00:50:56:9A:00:01' -Name 'MyReservation' -Network '10.2.2.0/24' -Comment 'This is a test reservation' -MicrosoftServer 'myserver'
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
Position: 4
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
IPv4 address or FQDN of the Microsoft DHCP server to use for the reservation.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ms_server
Possible values:

Required: False
Position: 5
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

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
Subnet to add the reservation to

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 3
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
