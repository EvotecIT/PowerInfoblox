---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Add-InfoBloxDNSRecord
## SYNOPSIS
Creates an Infoblox DNS record.

## SYNTAX
### Typed (Default)
```powershell
Add-InfoBloxDNSRecord -Type <string> [-Name <string>] [-IPAddress <string>] [-CanonicalName <string>] [-PtrName <string>] [-Text <string>] [-MailExchanger <string>] [-Preference <int>] [-NameServer <string>] [-Address <string[]>] [-View <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Properties
```powershell
Add-InfoBloxDNSRecord -Properties <IDictionary> -Type <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a typed A, AAAA, CNAME, HOST, PTR, MX, NS, or TXT record. Other WAPI
DNS record types can be created by supplying their fields through Properties.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Add-InfoBloxDNSRecord -Name 'host.example.com' -IPv4Address '192.0.2.10' -Type A
```


### EXAMPLE 2
```powershell
PS > Add-InfoBloxDNSRecord -Name 'alias.example.com' -CanonicalName 'host.example.com' -Type CNAME
```


### EXAMPLE 3
```powershell
PS > Add-InfoBloxDNSRecord -Name '5.10.2.10.in-addr.arpa' -PtrName 'host.example.com' -Type PTR -View Internal
```


### EXAMPLE 4
```powershell
PS > Add-InfoBloxDNSRecord -Name 'example.com' -MailExchanger 'mail.example.com' -Preference 10 -Type MX
```


### EXAMPLE 5
```powershell
PS > Add-InfoBloxDNSRecord -Type SRV -Properties @{ name = '_service._tcp.example.com'; target = 'host.example.com'; port = 443; priority = 10; weight = 5 }
```


## PARAMETERS

### -Address
Optional IPv4 or IPv6 glue addresses for an NS record. Omit this parameter when
the nameserver does not require glue.

```yaml
Type: String[]
Parameter Sets: Typed
Aliases: Addresses
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CanonicalName
The canonical target of a CNAME record.

```yaml
Type: String
Parameter Sets: Typed
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPAddress
The IPv4 or IPv6 address used by A, AAAA, HOST, and reverse-mapping PTR records.

```yaml
Type: String
Parameter Sets: Typed
Aliases: IPv4Address, IPv6Address
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailExchanger
The mail exchanger of an MX record.

```yaml
Type: String
Parameter Sets: Typed
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The record name. PTR records created from an IP address do not require Name.

```yaml
Type: String
Parameter Sets: Typed
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameServer
The authoritative server name of an NS record.

```yaml
Type: String
Parameter Sets: Typed
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Preference
The MX preference from 0 through 65535.

```yaml
Type: Int32
Parameter Sets: Typed
Aliases: None
Possible values:

Required: False
Position: named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
A field dictionary for a WAPI DNS record type that does not use the typed parameters.

```yaml
Type: IDictionary
Parameter Sets: Properties
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PtrName
The target domain name of a PTR record.

```yaml
Type: String
Parameter Sets: Typed
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
The exact TXT record value. Character casing is preserved.

```yaml
Type: String
Parameter Sets: Typed
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The WAPI DNS record type. The legacy LBDN name is normalized to DTCLBDN.

```yaml
Type: String
Parameter Sets: Typed, Properties
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS view in which to create a typed record. When omitted, WAPI uses its default view.

```yaml
Type: String
Parameter Sets: Typed
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
