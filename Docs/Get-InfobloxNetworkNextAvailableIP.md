---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxNetworkNextAvailableIP
## SYNOPSIS
Gets the next available IPv4 addresses from an Infoblox network.

## SYNTAX
### Network (Default)
```powershell
Get-InfobloxNetworkNextAvailableIP -Network <string> [-Quantity <int>] [<CommonParameters>]
```

### NetworkRef
```powershell
Get-InfobloxNetworkNextAvailableIP -NetworkRef <string> [-Quantity <int>] [<CommonParameters>]
```

## DESCRIPTION
Calls the Infoblox WAPI next_available_ip function for a network selected by
CIDR value or object reference.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxNetworkNextAvailableIP -Network '192.0.2.0/24'
```

Returns one available address from the specified network.

### EXAMPLE 2
```powershell
PS > Get-InfobloxNetworkNextAvailableIP -NetworkRef 'network/ZG5zLm5ldHdvcmsu...' -Count 3
```

Returns three available addresses using a network object reference.

## PARAMETERS

### -Network
Specifies the IPv4 network in CIDR notation. The command resolves it to an object reference.

```yaml
Type: String
Parameter Sets: Network
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkRef
Specifies an Infoblox network object reference, such as network/ZG5zLm5ldHdvcmsu...

```yaml
Type: String
Parameter Sets: NetworkRef
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quantity
Specifies how many available addresses to return. The default is 1. Count is an alias.

```yaml
Type: Int32
Parameter Sets: Network, NetworkRef
Aliases: Count
Possible values:

Required: False
Position: named
Default value: 1
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
