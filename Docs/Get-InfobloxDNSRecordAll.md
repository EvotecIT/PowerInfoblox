---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDNSRecordAll
## SYNOPSIS
Gets DNS records across all record types.

## SYNTAX
### __AllParameterSets
```powershell
Get-InfobloxDNSRecordAll [[-Name] <string>] [[-Zone] <string>] [[-View] <string>] [[-ReturnFields] <string[]>] [[-MaxResults] <int>] [-PartialMatch] [-FetchFromSchema] [<CommonParameters>]
```

## DESCRIPTION
Queries the Infoblox allrecords WAPI object and uses schema-aware preferred fields by default.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDNSRecordAll -Zone 'example.com'
```


### EXAMPLE 2
```powershell
PS > Get-InfobloxDNSRecordAll -Name 'mail' -PartialMatch -ReturnFields name,type,record -MaxResults 100
```


## PARAMETERS

### -FetchFromSchema
Requests every field reported as readable by the connected Grid schema.

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
The maximum result count requested from WAPI.

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

### -Name
The DNS record name to match.

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
Uses WAPI regular-expression matching for Name, Zone, and View.

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
Requests the specified fields instead of the default schema-aware field set.

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

### -View
The DNS view to match.

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

### -Zone
The DNS zone to match.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
