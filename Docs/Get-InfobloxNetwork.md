---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxNetwork
## SYNOPSIS
Retrieves IPv4 networks from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxNetwork [[-Network] <string>] [[-ReturnFields] <string[]>] [[-MaxResults] <int>] [-Partial] [-All] [-FetchFromSchema] [-Native] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI network objects by exact or partial network value, or
returns all networks. Unless Native is specified, each result is enriched with
calculated address-range information and selected Infoblox properties.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxNetwork -Network '192.0.2.0/24'
```

Returns and enriches the specified network.

### EXAMPLE 2
```powershell
PS > Get-InfobloxNetwork -Network '192.0.2' -Partial -MaxResults 25
```

Returns up to 25 networks whose network value partially matches 192.0.2.

### EXAMPLE 3
```powershell
PS > Get-InfobloxNetwork -All -Native -ReturnFields network,comment,network_view
```

Returns native WAPI objects for all networks with the selected fields.

## PARAMETERS

### -All
Returns all networks up to MaxResults. Either Network or All must be supplied.

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

### -FetchFromSchema
Requests every field advertised for the network object by the connected WAPI schema.

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
Specifies the maximum number of results for All or Partial queries. The default is 1000000.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
Default value: 1000000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Native
Returns native WAPI network objects without calculated address-range enrichment.

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

### -Network
Specifies an IPv4 network in CIDR notation.

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

### -Partial
Uses partial matching for Network and applies MaxResults.

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

### -ReturnFields
Specifies the network fields to request. Duplicate field names are removed.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `System.Object[]`

## RELATED LINKS

- None
