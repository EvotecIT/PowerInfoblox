---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Get-InfobloxObjects
## SYNOPSIS
Retrieves generic Infoblox WAPI objects.

## SYNTAX
### ReferenceID
```powershell
Get-InfobloxObjects -ReferenceID <string[]> [-MaxResults <int>] [-FetchFromSchema] [-ReturnFields <string[]>] [<CommonParameters>]
```

### Objects
```powershell
Get-InfobloxObjects -Object <string> [-MaxResults <int>] [-FetchFromSchema] [-ReturnFields <string[]>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves objects either by WAPI object type or by one or more exact object
references. Use this command when no specialized PowerInfoblox getter exists.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-InfobloxObjects -Object 'record:caa' -ReturnFields name,ca_flag,ca_tag,ca_value -MaxResults 100
```

Returns up to 100 CAA records with the selected fields.

### EXAMPLE 2
```powershell
PS > Get-InfobloxObjects -ReferenceID 'record:txt/ZG5zLmJpbmRf...:notice.example.com/default' -FetchFromSchema
```

Retrieves the exact referenced object with all fields advertised by its schema.

## PARAMETERS

### -FetchFromSchema
Requests every field advertised for the selected object type by the connected WAPI schema.
For ReferenceID queries, the object type is taken from each reference.

```yaml
Type: SwitchParameter
Parameter Sets: ReferenceID, Objects
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxResults
Specifies the maximum number of objects returned when the WAPI endpoint supports it.

```yaml
Type: Int32
Parameter Sets: ReferenceID, Objects
Aliases: None
Possible values:

Required: False
Position: named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
Specifies the WAPI object type to retrieve, such as record:caa, network, or member.

```yaml
Type: String
Parameter Sets: Objects
Aliases: None
Possible values: ad_auth_service, admingroup, adminrole, adminuser, allendpoints, allnsgroup, allrecords, allrpzrecords, approvalworkflow, authpolicy, awsrte53taskgroup, awsuser, bfdtemplate, bulkhost, bulkhostnametemplate, cacertificate, capacityreport, captiveportal, certificate:authservice, csvimporttask, db_objects, dbsnapshot, ddns:principalcluster, ddns:principalcluster:group, deleted_objects, dhcp:statistics, dhcpfailover, dhcpoptiondefinition, dhcpoptionspace, discovery, discovery:credentialgroup, discovery:device, discovery:devicecomponent, discovery:deviceinterface, discovery:deviceneighbor, discovery:devicesupportbundle, discovery:diagnostictask, discovery:gridproperties, discovery:memberproperties, discovery:sdnnetwork, discovery:status, discovery:vrf, discoverytask, distributionschedule, dns64group, dtc, dtc:allrecords, dtc:certificate, dtc:lbdn, dtc:monitor, dtc:monitor:http, dtc:monitor:icmp, dtc:monitor:pdp, dtc:monitor:sip, dtc:monitor:snmp, dtc:monitor:tcp, dtc:object, dtc:pool, dtc:record:a, dtc:record:aaaa, dtc:record:cname, dtc:record:naptr, dtc:record:srv, dtc:server, dtc:topology, dtc:topology:label, dtc:topology:rule, dxl:endpoint, extensibleattributedef, fileop, filterfingerprint, filtermac, filternac, filteroption, filterrelayagent, fingerprint, fixedaddress, fixedaddresstemplate, ftpuser, grid, grid:cloudapi, grid:cloudapi:cloudstatistics, grid:cloudapi:tenant, grid:cloudapi:vm, grid:cloudapi:vmaddress, grid:dashboard, grid:dhcpproperties, grid:dns, grid:filedistribution, grid:license_pool, grid:license_pool_container, grid:maxminddbinfo, grid:member:cloudapi, grid:servicerestart:group, grid:servicerestart:group:order, grid:servicerestart:request, grid:servicerestart:request:changedobject, grid:servicerestart:status, grid:threatanalytics, grid:threatprotection, grid:x509certificate, hostnamerewritepolicy, hsm:allgroups, hsm:safenetgroup, hsm:thalesgroup, ipam:statistics, ipv4address, ipv6address, ipv6dhcpoptiondefinition, ipv6dhcpoptionspace, ipv6fixedaddress, ipv6fixedaddresstemplate, ipv6network, ipv6networkcontainer, ipv6networktemplate, ipv6range, ipv6rangetemplate, ipv6sharednetwork, kerberoskey, ldap_auth_service, lease, license:gridwide, localuser:authservice, macfilteraddress, mastergrid, member, member:dhcpproperties, member:dns, member:filedistribution, member:license, member:parentalcontrol, member:threatanalytics, member:threatprotection, memberdfp, msserver, msserver:adsites:domain, msserver:adsites:site, msserver:dhcp, msserver:dns, mssuperscope, namedacl, natgroup, network, network_discovery, networkcontainer, networktemplate, networkuser, networkview, notification:rest:endpoint, notification:rest:template, notification:rule, nsgroup, nsgroup:delegation, nsgroup:forwardingmember, nsgroup:forwardstubserver, nsgroup:stubmember, orderedranges, orderedresponsepolicyzones, outbound:cloudclient, parentalcontrol:avp, parentalcontrol:blockingpolicy, parentalcontrol:subscriber, parentalcontrol:subscriberrecord, parentalcontrol:subscribersite, permission, pxgrid:endpoint, radius:authservice, range, rangetemplate, record:a, record:aaaa, record:alias, record:caa, record:cname, record:dhcid, record:dname, record:dnskey, record:ds, record:dtclbdn, record:host, record:host_ipv4addr, record:host_ipv6addr, record:mx, record:naptr, record:ns, record:nsec, record:nsec3, record:nsec3param, record:ptr, record:rpz:a, record:rpz:a:ipaddress, record:rpz:aaaa, record:rpz:aaaa:ipaddress, record:rpz:cname, record:rpz:cname:clientipaddress, record:rpz:cname:clientipaddressdn, record:rpz:cname:ipaddress, record:rpz:cname:ipaddressdn, record:rpz:mx, record:rpz:naptr, record:rpz:ptr, record:rpz:srv, record:rpz:txt, record:rrsig, record:srv, record:tlsa, record:txt, record:unknown, recordnamepolicy, request, restartservicestatus, rir, rir:organization, roaminghost, ruleset, saml:authservice, scavengingtask, scheduledtask, search, sharednetwork, sharedrecord:a, sharedrecord:aaaa, sharedrecord:cname, sharedrecord:mx, sharedrecord:srv, sharedrecord:txt, sharedrecordgroup, smartfolder:children, smartfolder:global, smartfolder:personal, snmpuser, superhost, superhostchild, syslog:endpoint, tacacsplus:authservice, taxii, tftpfiledir, threatanalytics:analytics_whitelist, threatanalytics:moduleset, threatanalytics:whitelist, threatinsight:cloudclient, threatprotection:grid:rule, threatprotection:profile, threatprotection:profile:rule, threatprotection:rule, threatprotection:rulecategory, threatprotection:ruleset, threatprotection:ruletemplate, threatprotection:statistics, upgradegroup, upgradeschedule, upgradestatus, userprofile, vdiscoverytask, view, vlan, vlanrange, vlanview, zone_auth, zone_auth_discrepancy, zone_delegated, zone_forward, zone_rp, zone_stub

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
Specifies one or more exact Infoblox WAPI object references to retrieve.

```yaml
Type: String[]
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnFields
Specifies the WAPI fields to return.

```yaml
Type: String[]
Parameter Sets: ReferenceID, Objects
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
