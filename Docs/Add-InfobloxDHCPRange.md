---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxDHCPRange
## SYNOPSIS
Adds a DHCP range to Infoblox.

## SYNTAX
### __AllParameterSets
```powershell
Add-InfobloxDHCPRange [-StartAddress] <string> [-EndAddress] <string> [[-Name] <string>] [[-Comment] <Object>] [[-NetworkView] <string>] [[-MSServer] <string>] [[-ExtensinbleAttribute] <IDictionary>] [[-Options] <array>] [[-MSOptions] <array>] [[-FailoverAssociation] <string>] [[-ServerAssociationType] <string>] [[-Exclude] <array>] [[-DDNSUpdateMode] <string>] [[-DDNSEnabled] <Boolean>] [-ReturnOutput] [-AlwaysUpdateDns] [-Disable] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function adds a DHCP range to Infoblox. It requires an established connection to an Infoblox server, which can be done using the Connect-Infoblox function.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxDHCPRange -StartAddress '192.168.1.100' -EndAddress '192.168.1.200' -Name 'DHCP Range 1' -Comment 'This is a DHCP range.'
Adds a DHCP range from 192.168.1.100 to 192.168.1.200 with the name 'DHCP Range 1' and a comment 'This is a DHCP range.'.
```


### EXAMPLE 2
```powershell
PS > Add-InfobloxDHCPRange -StartAddress '10.22.41.15' -EndAddress '10.22.41.30'
Adds a reserved range from 10.22.41.15 to 10.22.41.30
```


### EXAMPLE 3
```powershell
PS > $addInfobloxDHCPRangeSplat = @{
    StartAddress = '10.22.41.51'
    EndAddress = '10.22.41.60'
    Verbose = $true
    MSServer = 'dhcp2016.evotec.pl'
    Name = 'DHCP Range Me?'
    ServerAssociationType = 'MS_SERVER'
}
```

Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat

### EXAMPLE 4
```powershell
PS > Add-InfobloxDHCPRange -StartAddress '10.22.41.100' -EndAddress '10.22.41.150' -DDNSUpdateMode Override -DDNSEnabled $false
Adds a DHCP range that overrides the inherited DDNS setting and disables DDNS updates.
```


### EXAMPLE 5
```powershell
PS > $addInfobloxDHCPRangeSplat = @{
    StartAddress          = '10.22.41.70'
    EndAddress            = '10.22.41.90'
    Verbose               = $true
    MSServer              = 'dhcp2019.evotec.pl'
    Name                  = 'DHCP Range Me2?'
    ServerAssociationType = 'MS_SERVER'
    Exclude               = '10.22.41.75-10.22.41.79'
}
```

Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat

### EXAMPLE 6
```powershell
PS > $addInfobloxDHCPRangeSplat = @{
    StartAddress = '10.10.12.5'
    EndAddress   = '10.10.12.10'
    Options      = @(
        New-InfobloxOption -Name "dhcp-lease-time" -Number 51 -UseOption -Value '86400' -VendorClass 'DHCP'
        New-InfobloxOption -Name "domain-name-servers" -Number 6 -UseOption -Value '192.168.0.15' -VendorClass 'DHCP'
        New-InfobloxOption -Name 'routers' -Number 3 -UseOption -Value '192.168.11.12' -VendorClass 'DHCP'
        New-InfobloxOption -Name 'time-servers' -Number 4 -UseOption -Value '11' -VendorClass 'DHCP'
    )
    Verbose      = $true
}
```

Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat

## PARAMETERS

### -AlwaysUpdateDns
Controls whether the DHCP server always updates DNS when DDNS is enabled. This setting does not enable DDNS.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
A comment for the DHCP range. Null, blank, and Boolean false values are treated as no comment.

```yaml
Type: Object
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSEnabled
Enables or disables DDNS on the range. Supplying this value automatically selects local override mode.

```yaml
Type: Boolean
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSUpdateMode
Controls whether the range inherits the DDNS enablement setting or overrides it locally.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values: Inherit, Override

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disable
If this switch is present, the DHCP range will be disabled.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndAddress
The ending IP address of the DHCP range. This parameter is mandatory.

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

### -Exclude
An array of IP addresses or IP address ranges to be excluded from the DHCP range.

```yaml
Type: Array
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttribute
An extensible attribute to be added to the DHCP range. ExtensibleAttribute is
a correctly spelled alias retained for discoverability.

```yaml
Type: IDictionary
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttribute
Possible values:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailoverAssociation
The failover association for the DHCP range.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: failover_association
Possible values:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MSOptions
An array of Microsoft options to be added to the DHCP range.

```yaml
Type: Array
Parameter Sets: __AllParameterSets
Aliases: ms_options
Possible values:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MSServer
The IPv4 address or FQDN of the Microsoft DHCP server to which the range will be added.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the DHCP range.

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

### -NetworkView
The network view in which the DHCP range will be added. The default is 'default'.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 4
Default value: default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Options
An array of options to be added to the DHCP range.

```yaml
Type: Array
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnOutput
If this switch is present, the function will return the output of the operation.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerAssociationType
The server association type for the DHCP range. The possible values are 'MEMBER', 'MS_FAILOVER', 'NONE', 'MS_SERVER', 'FAILOVER'.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values: MEMBER, MS_FAILOVER, NONE, MS_SERVER, FAILOVER

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartAddress
The starting IP address of the DHCP range. This parameter is mandatory.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
