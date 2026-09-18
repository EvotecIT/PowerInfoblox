---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Set-InfobloxDHCPRange
## SYNOPSIS
Sets the DHCP range configuration on an Infoblox server.

## SYNTAX
### ReferenceID
```powershell
Set-InfobloxDHCPRange -ReferenceID <string> [-Comment <Object>] [-MSServer <string>] [-ExtensinbleAttribute <IDictionary>] [-Options <array>] [-MSOptions <array>] [-FailoverAssociation <string>] [-ServerAssociationType <string>] [-Exclude <array>] [-AlwaysUpdateDns] [-DDNSUpdateMode <string>] [-DDNSEnabled <Boolean>] [-Disable] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function modifies the DHCP range configuration on an Infoblox server. It allows setting comments, Microsoft options, and other DHCP options.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Set-InfobloxDHCPRange -ReferenceID 'DHCPRange-1' -Comment 'This is a DHCP range.'
```


### EXAMPLE 2
```powershell
PS > Set-InfobloxDHCPRange -ReferenceID 'DHCPRange-1' -DDNSUpdateMode Override -DDNSEnabled $false
Overrides the inherited DDNS setting and disables DDNS updates for the range.
```


### EXAMPLE 3
```powershell
PS > Set-InfobloxDHCPRange -ReferenceID 'DHCPRange-1' -DDNSUpdateMode Inherit
Restores the inherited DDNS enablement setting for the range.
```


### EXAMPLE 4
```powershell
PS > Set-InfobloxDHCPRange -ReferenceID 'DHCPRange-1' -Options @(
    New-InfobloxOption -Name "dhcp-lease-time" -Number 51 -UseOption -Value '86400' -VendorClass 'DHCP'
    New-InfobloxOption -Name "domain-name-servers" -Number 6 -UseOption -Value '192.168.0.15' -VendorClass 'DHCP'
    New-InfobloxOption -Name 'routers' -Number 3 -UseOption -Value '192.168.11.12' -VendorClass 'DHCP'
    New-InfobloxOption -Name 'time-servers' -Number 4 -UseOption -Value '11' -VendorClass 'DHCP'
)
```


## PARAMETERS

### -AlwaysUpdateDns
Controls whether the DHCP server always updates DNS when DDNS is enabled. This setting does not enable DDNS.

```yaml
Type: SwitchParameter
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
A comment to associate with the DHCP range. Pass an empty, null, or Boolean false value to clear the comment.

```yaml
Type: Object
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSEnabled
Enables or disables DDNS on the range. Supplying this value automatically selects local override mode.

```yaml
Type: Boolean
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSUpdateMode
Controls whether the range inherits the DDNS enablement setting or overrides it locally.

```yaml
Type: String
Parameter Sets: ReferenceID
Aliases: None
Possible values: Inherit, Override

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disable
Indicates whether to disable the DHCP range.

```yaml
Type: SwitchParameter
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
An array of IP addresses or address ranges to exclude from the DHCP range.

```yaml
Type: Array
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttribute
A hashtable of extensible attributes to associate with the DHCP range.

```yaml
Type: IDictionary
Parameter Sets: ReferenceID
Aliases: ExtensibleAttribute
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailoverAssociation
The failover association for the DHCP range.

```yaml
Type: String
Parameter Sets: ReferenceID
Aliases: failover_association
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MSOptions
An array of Microsoft-specific DHCP options.

```yaml
Type: Array
Parameter Sets: ReferenceID
Aliases: ms_options
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MSServer
The IPv4 address or FQDN of the Microsoft DHCP server associated with the range.

```yaml
Type: String
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Options
An array of general DHCP options.

```yaml
Type: Array
Parameter Sets: ReferenceID
Aliases: None
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
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerAssociationType
The type of server association. Valid values are 'MEMBER', 'MS_FAILOVER', 'NONE', 'MS_SERVER', 'FAILOVER'.

```yaml
Type: String
Parameter Sets: ReferenceID
Aliases: None
Possible values: MEMBER, MS_FAILOVER, NONE, MS_SERVER, FAILOVER

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
