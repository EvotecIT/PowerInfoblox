---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxIPAddress
## SYNOPSIS
Get Infoblox IP Address information for given network or IP address

## SYNTAX
### Network
```powershell
Get-InfobloxIPAddress [-Network <string>] [-Status <string>] [-Name <string>] [-Count <int>] [<CommonParameters>]
```

### IPv4
```powershell
Get-InfobloxIPAddress [-IPv4Address <string>] [-Status <string>] [-Name <string>] [-Count <int>] [<CommonParameters>]
```

## DESCRIPTION
Get Infoblox IP Address information for given network or IP address

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxIPAddress -Network '10.2.2.0/24'
```


### EXAMPLE 2
```powershell
PS > Get-InfobloxIPAddress -Network '10.2.2.0/24' -Status Used -Verbose | Format-Table
```


### EXAMPLE 3
```powershell
PS > Get-InfobloxIPAddress -Network '10.2.2.0' -Verbose | Format-Table
```


## PARAMETERS

### -Count
Limit the number of results returned

```yaml
Type: Int32
Parameter Sets: Network, IPv4
Aliases: Quantity
Possible values:

Required: False
Position: named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPv4Address
Find IP address information for a specific IP address

```yaml
Type: String
Parameter Sets: IPv4
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Get IP addresses with a specific name

```yaml
Type: String
Parameter Sets: Network, IPv4
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
Find IP address information for a specific network

```yaml
Type: String
Parameter Sets: Network
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Get IP addresses with a specific status, either Used or Unused

```yaml
Type: String
Parameter Sets: Network, IPv4
Aliases: None
Possible values: Used, Unused

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
