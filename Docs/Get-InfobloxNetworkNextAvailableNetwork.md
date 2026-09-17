---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxNetworkNextAvailableNetwork
## SYNOPSIS
Get the next available network from a network container

## SYNTAX
### Network (Default)
```powershell
Get-InfobloxNetworkNextAvailableNetwork -Network <string> -Cidr <int> [-Quantity <int>] [<CommonParameters>]
```

### NetworkRef
```powershell
Get-InfobloxNetworkNextAvailableNetwork -NetworkRef <string> -Cidr <int> [-Quantity <int>] [<CommonParameters>]
```

## DESCRIPTION
Get the next available network from a network container

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxNetworkNextAvailableNetwork -Network '10.2.0.0/16' -Quantity 5 -Cidr 27 -Verbose | Format-Table
```


## PARAMETERS

### -Cidr
The CIDR of the network to return

```yaml
Type: Int32
Parameter Sets: Network, NetworkRef
Aliases: None
Possible values:

Required: True
Position: named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
Provide the network container to search for the next available network

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
Provide the network container reference to search for the next available network (alternative to Network)

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
How many networks to return

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
