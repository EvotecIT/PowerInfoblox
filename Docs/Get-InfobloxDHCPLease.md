---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDHCPLease
## SYNOPSIS
Retrieves DHCP leases from an Infoblox server.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxDHCPLease [[-Network] <string>] [[-IPv4Address] <string>] [[-Hostname] <string>] [[-ReturnFields] <string[]>] [[-MaxResults] <int>] [-PartialMatch] [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries Infoblox WAPI lease objects. Results can be filtered by network,
IPv4 address, or host name. Specify PartialMatch to use WAPI regular-expression
matching for every supplied filter.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDHCPLease -Network '192.0.2.0/24'
```

Returns leases for the specified network.

### EXAMPLE 2
```powershell
PS > Get-InfobloxDHCPLease -Hostname 'client-01' -PartialMatch -ReturnFields address,client_hostname,binding_state
```

Returns leases whose host name partially matches client-01 and limits the returned fields.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the lease object by the connected WAPI schema.

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

### -Hostname
Filters leases by client host name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPv4Address
Filters leases by IPv4 address.

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

### -MaxResults
Specifies the maximum number of leases returned. The default is 1000000.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 4
Default value: 1000000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
Filters leases by network in CIDR notation, such as 192.0.2.0/24.

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
Uses partial matching instead of exact matching for the supplied filters.

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
Specifies the lease fields to return. Duplicate field names are removed.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
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
