---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# New-InfobloxOption
## SYNOPSIS
Creates a dummy Infoblox option to use within other cmdlets

## SYNTAX
### __AllParameterSets
```powershell
New-InfobloxOption [-Name] <string> [-Number] <int> [-Value] <string> [-VendorClass] <string> [-UseOption] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new Infoblox option. It's just syntactic sugar to make it easier to create options to use within other cmdlets.

## EXAMPLES

### EXAMPLE 1
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
    MsOptions      = @(
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

### -Name
The name of the Infoblox option. This parameter is mandatory.

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

### -Number
The number of the Infoblox option. This parameter is mandatory.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: Num
Possible values:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseOption
A switch indicating whether to use the option. This parameter is mandatory.

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

### -Value
The value of the Infoblox option. This parameter is mandatory.

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

### -VendorClass
The vendor class of the Infoblox option. This parameter is mandatory.

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
