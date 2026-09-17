---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxDNSRecord
## SYNOPSIS
Gets Infoblox DNS records of one WAPI record type.

## SYNTAX
### ByFilter (Default)
```powershell
Get-InfobloxDNSRecord [-Name <string>] [-Zone <string>] [-View <string>] [-PartialMatch] [-Type <string>] [-FetchFromSchema] [-ReturnFields <string[]>] [-MaxResults <int>] [<CommonParameters>]
```

### ByReference
```powershell
Get-InfobloxDNSRecord -ReferenceID <string> [-FetchFromSchema] [-ReturnFields <string[]>] [<CommonParameters>]
```

## DESCRIPTION
Queries a record:<type> WAPI endpoint. Common record types use schema-filtered preferred fields.
Other current or future record types can be queried by name without waiting for a new ValidateSet.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxDNSRecord -Type A -Name 'host.example.com'
```


### EXAMPLE 2
```powershell
PS > Get-InfobloxDNSRecord -Type MX -Zone 'example.com' -ReturnFields name,mail_exchanger,preference
```


### EXAMPLE 3
```powershell
PS > Get-InfobloxDNSRecord -ReferenceID 'record:a/example-reference:host.example.com/default'
```


## PARAMETERS

### -FetchFromSchema
Requests every field reported as readable by the connected Grid schema.

```yaml
Type: SwitchParameter
Parameter Sets: ByFilter, ByReference
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
Parameter Sets: ByFilter
Aliases: None
Possible values:

Required: False
Position: named
Default value: 1000000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The DNS record name to match.

```yaml
Type: String
Parameter Sets: ByFilter
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PartialMatch
Uses WAPI regular-expression matching for Name, Zone, and View.

```yaml
Type: SwitchParameter
Parameter Sets: ByFilter
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
The exact DNS record WAPI object reference to retrieve. The record type is inferred from it.

```yaml
Type: String
Parameter Sets: ByReference
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnFields
Requests the specified fields without changing the caller's explicit selection.

```yaml
Type: String[]
Parameter Sets: ByFilter, ByReference
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The WAPI DNS record type. Host is the default. The legacy LBDN name is normalized to DTCLBDN.

```yaml
Type: String
Parameter Sets: ByFilter
Aliases: None
Possible values:

Required: False
Position: named
Default value: Host
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS view to match.

```yaml
Type: String
Parameter Sets: ByFilter
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Zone
The DNS zone to match.

```yaml
Type: String
Parameter Sets: ByFilter
Aliases: None
Possible values:

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
