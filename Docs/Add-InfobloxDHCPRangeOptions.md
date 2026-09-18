---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxDHCPRangeOptions
## SYNOPSIS
Adds DHCP range options to an Infoblox server.

## SYNTAX
### NetworkOption
```powershell
Add-InfobloxDHCPRangeOptions -Type <string> -Network <string> -Name <string> [-Number <Int32>] [-Value <string>] [-VendorClass <string>] [-UseOption] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ReferenceOption
```powershell
Add-InfobloxDHCPRangeOptions -Type <string> -ReferenceID <string> -Name <string> [-Number <Int32>] [-Value <string>] [-VendorClass <string>] [-UseOption] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function adds specified DHCP range options to an Infoblox server. It allows adding options and Microsoft-specific options for a given network or reference ID.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxDHCPRangeOptions -Type 'Options' -Network '192.168.1.0/24' -Name 'domain-name-servers' -Number 6 -Value '192.168.0.15' -VendorClass 'DHCP' -UseOption
```


### EXAMPLE 2
```powershell
PS > Add-InfobloxDHCPRangeOptions -Type 'MsOptions' -ReferenceID 'DHCPRange-1' -Name 'time-servers' -Number 4 -Value '11' -VendorClass 'DHCP'
```


## PARAMETERS

### -Name
The name of the DHCP option to be added.

```yaml
Type: String
Parameter Sets: NetworkOption, ReferenceOption
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
The network for which to add DHCP options.

```yaml
Type: String
Parameter Sets: NetworkOption
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Number
The number of the DHCP option.

```yaml
Type: Int32
Parameter Sets: NetworkOption, ReferenceOption
Aliases: Num
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
The unique identifier for the DHCP range to be modified.

```yaml
Type: String
Parameter Sets: ReferenceOption
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the type of options to add. Valid values are 'Options' and 'MsOptions'.

```yaml
Type: String
Parameter Sets: NetworkOption, ReferenceOption
Aliases: None
Possible values: Options, MsOptions

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseOption
Indicates whether to use the option.

```yaml
Type: SwitchParameter
Parameter Sets: NetworkOption, ReferenceOption
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
The value of the DHCP option.

```yaml
Type: String
Parameter Sets: NetworkOption, ReferenceOption
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VendorClass
The vendor class of the DHCP option.

```yaml
Type: String
Parameter Sets: NetworkOption, ReferenceOption
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
