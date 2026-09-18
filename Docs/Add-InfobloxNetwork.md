---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfobloxNetwork
## SYNOPSIS
Adds a network to Infoblox.

## SYNTAX
### __AllParameterSets
```powershell
Add-InfobloxNetwork [-Network] <string> [[-Comment] <string>] [[-NetworkView] <string>] [[-DHCPGateway] <string>] [[-DHCPLeaseTime] <string>] [[-DHCPDomainNameServers] <string>] [[-Options] <array>] [[-MSOptions] <array>] [[-Members] <string[]>] [[-ExtensinbleAttributeName] <string>] [[-ExtensinbleAttributeSite] <string>] [[-ExtensinbleAttributeState] <string>] [[-ExtensinbleAttributeCountry] <string>] [[-ExtensinbleAttributeRegion] <string>] [[-ExtensinbleAttributeVLAN] <string>] [[-ExtensinbleAttribute] <IDictionary>] [-AutoCreateReverseZone] [-ReturnOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function adds a network to Infoblox. It requires a connection to an Infoblox server, which can be established using the Connect-Infoblox function.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfobloxNetwork -Network '192.168.1.0/24' -Comment 'Test network' -DHCPGateway '192.168.1.1'
```


### EXAMPLE 2
```powershell
PS > $addInfobloxSubnetSplat = @{
    Subnet                      = '10.22.35.0/24'
    Comment                     = "Oki dokii"
    AutoCreateReverseZone       = $true
    DHCPGateway                 = "10.22.35.1"
    DHCPLeaseTime               = 5000
    DHCPDomainNameServers       = "192.168.4.56,192.168.4.57"
    ExtensinbleAttributeCountry = "Poland"
    ExtensinbleAttributeName    = "Test"
    ExtensinbleAttributeRegion  = "Europe"
    ExtensinbleAttributeSite    = "Site1"
    ExtensinbleAttributeState   = "Mazowieckie"
    ExtensinbleAttributeVLAN    = "810"
}
```

Add-InfobloxNetwork @addInfobloxSubnetSplat

### EXAMPLE 3
```powershell
PS > $addInfobloxSubnetSplat = @{
    Subnet                = '10.22.36.0/24'
    Comment               = "Oki dokii"
    AutoCreateReverseZone = $true
    DHCPGateway           = "10.22.36.1"
    DHCPLeaseTime         = 5000
    DHCPDomainNameServers = "192.168.4.56,192.168.4.57"
    ExtensinbleAttribute  = [ordered] @{
        Name    = 'Test'
        VLAN    = '810'
        Country = 'Poland'
        Region  = 'Europe'
        Site    = 'Site1'
    }
}
```

Add-InfobloxNetwork @addInfobloxSubnetSplat

## PARAMETERS

### -AutoCreateReverseZone
A switch that, when present, indicates that a reverse zone should be automatically created for the network.

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
An optional comment for the network.

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

### -DHCPDomainNameServers
The DHCP domain name servers for the network.

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

### -DHCPGateway
The DHCP gateway for the network.

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

### -DHCPLeaseTime
The DHCP lease time for the network.

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

### -ExtensinbleAttribute
A dictionary of additional extensible attributes to associate with the network.
ExtensibleAttribute is a correctly spelled alias retained for discoverability.

```yaml
Type: IDictionary
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttribute
Possible values:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttributeCountry
The country associated with the network as an extensible attribute. ExtensibleAttributeCountry
is a correctly spelled alias retained for discoverability.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttributeCountry
Possible values:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttributeName
The name of an extensible attribute for the network. ExtensibleAttributeName is
a correctly spelled alias retained for discoverability.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttributeName
Possible values:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttributeRegion
The region associated with the network as an extensible attribute. ExtensibleAttributeRegion
is a correctly spelled alias retained for discoverability.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttributeRegion
Possible values:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttributeSite
The site associated with the network as an extensible attribute. ExtensibleAttributeSite
is a correctly spelled alias retained for discoverability.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttributeSite
Possible values:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttributeState
The state associated with the network as an extensible attribute. ExtensibleAttributeState
is a correctly spelled alias retained for discoverability.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttributeState
Possible values:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtensinbleAttributeVLAN
The VLAN associated with the network as an extensible attribute. ExtensibleAttributeVLAN
is a correctly spelled alias retained for discoverability.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExtensibleAttributeVLAN
Possible values:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Members
An array of DHCP members to associate with the network.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 8
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
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
The network to add. This parameter is mandatory.

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

### -NetworkView
The network view in which to add the network. Defaults to 'default'.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
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
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnOutput
A switch that, when present, indicates that the output of the command should be returned.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
