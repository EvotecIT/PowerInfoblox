---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDHCPRange
## SYNOPSIS
Retrieves DHCP range configuration from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxDHCPRange [[-ReferenceID] <string>] [[-Network] <string>] [[-ReturnFields] <string[]>] [[-MaxResults] <int>] [-PartialMatch] [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the DHCP range configuration from an Infoblox server. It allows filtering by ReferenceID, Network, and other parameters.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDHCPRange -ReferenceID 'DHCPRange-1'
```


### EXAMPLE 2
```powershell
PS > Get-InfobloxDHCPRange -Network '192.168.1' -PartialMatch
```


### EXAMPLE 3
```powershell
PS > Get-InfobloxDHCPRange -Network '192.168.1.0/24' -FetchFromSchema
```


## PARAMETERS

### -FetchFromSchema
Indicates whether to fetch return fields from the schema.

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

### -MaxResults
The maximum number of results to return. Default is 1,000,000.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 3
Default value: 1000000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
The network for which to retrieve DHCP ranges.

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

### -PartialMatch
Indicates whether to perform a partial match on the network.

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

### -ReferenceID
The unique identifier for the DHCP range to be retrieved.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnFields
An array of fields to be returned in the response.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
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
