---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxDHCPRangeOptions
## SYNOPSIS
Removes DHCP range options from an Infoblox server.

## SYNTAX
### NetworkOption
```powershell
Remove-InfobloxDHCPRangeOptions -Type <string> -Network <string> -Name <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ReferenceOption
```powershell
Remove-InfobloxDHCPRangeOptions -Type <string> -ReferenceID <string> -Name <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function removes specified DHCP range options from an Infoblox server. It allows removing options and Microsoft-specific options for a given network or reference ID.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxDHCPRangeOptions -Type 'Options' -Network '192.168.1.0/24' -Name 'domain-name-servers'
```


### EXAMPLE 2
```powershell
PS > Remove-InfobloxDHCPRangeOptions -Type 'MsOptions' -ReferenceID 'DHCPRange-1' -Name 'time-servers'
```


## PARAMETERS

### -Name
The name of the DHCP option to be removed.

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
The network for which to remove DHCP options.

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
Specifies the type of options to remove. Valid values are 'Options' and 'MsOptions'.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
