---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Set-InfobloxDNSRecord
## SYNOPSIS
Updates the value of an existing Infoblox DNS record.

## SYNTAX
### ByReferenceValue (Default)
```powershell
Set-InfobloxDNSRecord -ReferenceID <string> -Value <string> [-Type <string>] [-CurrentValue <string>] [-Preference <int>] [-Address <string[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByReferenceProperties
```powershell
Set-InfobloxDNSRecord -ReferenceID <string> -Properties <IDictionary> [-Type <string>] [-CurrentValue <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByNameProperties
```powershell
Set-InfobloxDNSRecord -RecordName <string> -Properties <IDictionary> -Type <string> [-View <string>] [-CurrentValue <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByNameValue
```powershell
Set-InfobloxDNSRecord -RecordName <string> -Value <string> -Type <string> [-View <string>] [-CurrentValue <string>] [-Preference <int>] [-Address <string[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates an existing DNS record by exact WAPI reference or by an unambiguous record name,
type, view, and optional current value. An ambiguous or mismatched name lookup lists candidates
and skips the update. Value maps to the
primary data field for A, AAAA, CNAME, HOST, MX, NS, PTR, and TXT records. Properties supports
structured HOST changes and other record types or multi-field updates without guessing at nested WAPI fields.
Type is optional and, when supplied, must match the type encoded in ReferenceID.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Set-InfobloxDNSRecord -ReferenceID 'record:cname/ZG5zLmJpbmRfY25h:test01.example.com/default' -Value 'target.example.com'
```

Updates the canonical target of a CNAME record.

### EXAMPLE 2
```powershell
PS > Set-InfobloxDNSRecord -ReferenceID 'record:a/ZG5zLmhvc3Q:192.0.2.10/test01.example.com/default' -Type A -Value '192.0.2.20'
```

Updates an A record and verifies that the reference identifies an A record.

### EXAMPLE 3
```powershell
PS > Set-InfobloxDNSRecord -ReferenceID 'record:txt/ZG5zLmJpbmRfdHh0:test01.example.com/default' -Value 'Verification=AbC123' -WhatIf
```

Previews a TXT record update without sending the PUT request.

### EXAMPLE 4
```powershell
PS > Set-InfobloxDNSRecord -ReferenceID 'record:host/example-reference:host.example.com/default' -Properties @{ ipv4addrs = @(@{ ipv4addr = '192.0.2.20' }) }
```

Replaces the IPv4 address collection of a HOST record with an explicitly structured WAPI value.

### EXAMPLE 5
```powershell
PS > Set-InfobloxDNSRecord -RecordName '10.2.0.192.in-addr.arpa' -Type PTR -View Internal -CurrentValue 'old.example.com' -Value 'new.example.com' -WhatIf
```

Previews changing only the PTR record whose current target matches old.example.com.

## PARAMETERS

### -Address
Optional NS glue addresses, updated together with Value. Supply an empty array
to clear existing glue addresses.

```yaml
Type: String[]
Parameter Sets: ByReferenceValue, ByNameValue
Aliases: Addresses
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CurrentValue
The expected existing value for an A, AAAA, CNAME, MX, NS, PTR, or TXT record. With
RecordName it selects the existing record; with ReferenceID it guards the update.

```yaml
Type: String
Parameter Sets: ByReferenceValue, ByReferenceProperties, ByNameProperties, ByNameValue
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Preference
An optional MX preference from 0 through 65535, updated together with Value.

```yaml
Type: Int32
Parameter Sets: ByReferenceValue, ByNameValue
Aliases: None
Possible values:

Required: False
Position: named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
A field dictionary for HOST records, complex record types, or updates that affect multiple fields.

```yaml
Type: IDictionary
Parameter Sets: ByReferenceProperties, ByNameProperties
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordName
The existing DNS record name to update. Type is required. Use CurrentValue when the name
identifies several records in a view. The -Name alias of Value remains the new value.

```yaml
Type: String
Parameter Sets: ByNameProperties, ByNameValue
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
The WAPI object reference of the DNS record to update, for example record:cname/... or record:a/....

```yaml
Type: String
Parameter Sets: ByReferenceValue, ByReferenceProperties
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Required with RecordName. With ReferenceID, optionally checks the type encoded in the reference.

```yaml
Type: String
Parameter Sets: ByReferenceValue, ByReferenceProperties, ByNameProperties, ByNameValue
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
The new record value. The WAPI field depends on the record type: ipv4addr for A, ipv6addr for AAAA,
canonical for CNAME, name for HOST, ptrdname for PTR, mail_exchanger for MX, nameserver for NS,
and text for TXT.

```yaml
Type: String
Parameter Sets: ByReferenceValue, ByNameValue
Aliases: Object, Name, PtrName, PTR, NameServer, Text, CanonicalName, IPAddress, MailExchanger
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
Limits a RecordName lookup to one DNS view.

```yaml
Type: String
Parameter Sets: ByNameProperties, ByNameValue
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
