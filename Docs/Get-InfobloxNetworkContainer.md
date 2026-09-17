---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxNetworkContainer
## SYNOPSIS
Get Infoblox Network Containers

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxNetworkContainer [[-Network] <string>] [[-MaxResults] <int>] [-PartialMatch] [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Get Infoblox Network Containers

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfoBloxNetworkContainer -Network '10.2.0.0/16' -Verbose | Format-Table
```


### EXAMPLE 2
```powershell
PS > Get-InfoBloxNetworkContainer -Network '10.2' -Verbose -PartialMatch | Format-Table
```


## PARAMETERS

### -FetchFromSchema
Fetch fields from schema. By default, only the _ref field is returned

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
Maximum number of results to return

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 1
Default value: 1000000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
Provide the network to search for network containers

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

### -PartialMatch
Allow partial matches

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
