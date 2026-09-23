---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxDnsRecord
## SYNOPSIS
Removes Infoblox DNS records.

## SYNTAX
### ByName (Default)
```powershell
Remove-InfobloxDnsRecord -Name <string[]> -Type <string> [-View <string>] [-Value <string>] [-RemoveAllMatching] [-SkipPTR] [-LogPath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByReference
```powershell
Remove-InfobloxDnsRecord -ReferenceID <string> [-Type <string>] [-RemoveAllMatching] [-SkipPTR] [-LogPath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes one DNS record selected by ReferenceID or records found by Name and Type. Value can
select a specific A, AAAA, CNAME, MX, NS, PTR, or TXT record with that name. Name-based
removal stops when the selected records are ambiguous unless RemoveAllMatching is supplied.
Associated PTR cleanup for A and AAAA records is limited to the same view and matching ptrdname.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxDnsRecord -ReferenceID 'record:mx/example-reference:example.com/default' -WhatIf
```


### EXAMPLE 2
```powershell
PS > Remove-InfobloxDnsRecord -Name 'host.example.com' -Type A -View Internal -WhatIf
```


### EXAMPLE 3
```powershell
PS > Remove-InfobloxDnsRecord -Name '5.10.2.10.in-addr.arpa' -Type PTR -Value 'host.example.com' -View Internal -WhatIf
```


### EXAMPLE 4
```powershell
PS > Remove-InfobloxDnsRecord -Name 'example.com' -Type MX -View default -RemoveAllMatching -WhatIf
```


## PARAMETERS

### -LogPath
The path to a log file that receives discovery, removal attempt, preview,
success, and failure messages.

```yaml
Type: String
Parameter Sets: ByName, ByReference
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
One or more exact DNS record names to find and remove.

```yaml
Type: String[]
Parameter Sets: ByName
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
The exact DNS record WAPI object reference to remove.

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

### -RemoveAllMatching
Explicitly allows every record returned for a Name, Type, and optional View to be removed.
Without this switch, an ambiguous lookup is skipped.

```yaml
Type: SwitchParameter
Parameter Sets: ByName, ByReference
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipPTR
Skips associated PTR record removal when removing A or AAAA records.

```yaml
Type: SwitchParameter
Parameter Sets: ByName, ByReference
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The WAPI record type. It is required with Name and optional as a safety check with ReferenceID.

```yaml
Type: String
Parameter Sets: ByName, ByReference
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
The existing record value to match when removing by Name: address for A/AAAA, canonical
target for CNAME, mail exchanger for MX, nameserver for NS, target FQDN for PTR, or text
for TXT. DNS names are compared without regard to case or a final dot; TXT is exact.

```yaml
Type: String
Parameter Sets: ByName
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
Limits a name-based lookup to one DNS view.

```yaml
Type: String
Parameter Sets: ByName
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
