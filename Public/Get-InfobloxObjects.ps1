﻿function Get-InfobloxObjects {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ReferenceID')]
        [string[]] $ReferenceID,
        [Parameter(Mandatory, ParameterSetName = 'Objects')]
        [ValidateSet(
            "ad_auth_service",
            "admingroup",
            "adminrole",
            "adminuser",
            "allendpoints",
            "allnsgroup",
            "allrecords",
            "allrpzrecords",
            "approvalworkflow",
            "authpolicy",
            "awsrte53taskgroup",
            "awsuser",
            "bfdtemplate",
            "bulkhost",
            "bulkhostnametemplate",
            "cacertificate",
            "capacityreport",
            "captiveportal",
            "certificate:authservice",
            "csvimporttask",
            "db_objects",
            "dbsnapshot",
            "ddns:principalcluster",
            "ddns:principalcluster:group",
            "deleted_objects",
            "dhcp:statistics",
            "dhcpfailover",
            "dhcpoptiondefinition",
            "dhcpoptionspace",
            "discovery",
            "discovery:credentialgroup",
            "discovery:device",
            "discovery:devicecomponent",
            "discovery:deviceinterface",
            "discovery:deviceneighbor",
            "discovery:devicesupportbundle",
            "discovery:diagnostictask",
            "discovery:gridproperties",
            "discovery:memberproperties",
            "discovery:sdnnetwork",
            "discovery:status",
            "discovery:vrf",
            "discoverytask",
            "distributionschedule",
            "dns64group",
            "dtc",
            "dtc:allrecords",
            "dtc:certificate",
            "dtc:lbdn",
            "dtc:monitor",
            "dtc:monitor:http",
            "dtc:monitor:icmp",
            "dtc:monitor:pdp",
            "dtc:monitor:sip",
            "dtc:monitor:snmp",
            "dtc:monitor:tcp",
            "dtc:object",
            "dtc:pool",
            "dtc:record:a",
            "dtc:record:aaaa",
            "dtc:record:cname",
            "dtc:record:naptr",
            "dtc:record:srv",
            "dtc:server",
            "dtc:topology",
            "dtc:topology:label",
            "dtc:topology:rule",
            "dxl:endpoint",
            "extensibleattributedef",
            "fileop",
            "filterfingerprint",
            "filtermac",
            "filternac",
            "filteroption",
            "filterrelayagent",
            "fingerprint",
            "fixedaddress",
            "fixedaddresstemplate",
            "ftpuser",
            "grid",
            "grid:cloudapi",
            "grid:cloudapi:cloudstatistics",
            "grid:cloudapi:tenant",
            "grid:cloudapi:vm",
            "grid:cloudapi:vmaddress",
            "grid:dashboard",
            "grid:dhcpproperties",
            "grid:dns",
            "grid:filedistribution",
            "grid:license_pool",
            "grid:license_pool_container",
            "grid:maxminddbinfo",
            "grid:member:cloudapi",
            "grid:servicerestart:group",
            "grid:servicerestart:group:order",
            "grid:servicerestart:request",
            "grid:servicerestart:request:changedobject",
            "grid:servicerestart:status",
            "grid:threatanalytics",
            "grid:threatprotection",
            "grid:x509certificate",
            "hostnamerewritepolicy",
            "hsm:allgroups",
            "hsm:safenetgroup",
            "hsm:thalesgroup",
            "ipam:statistics",
            "ipv4address",
            "ipv6address",
            "ipv6dhcpoptiondefinition",
            "ipv6dhcpoptionspace",
            "ipv6fixedaddress",
            "ipv6fixedaddresstemplate",
            "ipv6network",
            "ipv6networkcontainer",
            "ipv6networktemplate",
            "ipv6range",
            "ipv6rangetemplate",
            "ipv6sharednetwork",
            "kerberoskey",
            "ldap_auth_service",
            "lease",
            "license:gridwide",
            "localuser:authservice",
            "macfilteraddress",
            "mastergrid",
            "member",
            "member:dhcpproperties",
            "member:dns",
            "member:filedistribution",
            "member:license",
            "member:parentalcontrol",
            "member:threatanalytics",
            "member:threatprotection",
            "memberdfp",
            "msserver",
            "msserver:adsites:domain",
            "msserver:adsites:site",
            "msserver:dhcp",
            "msserver:dns",
            "mssuperscope",
            "namedacl",
            "natgroup",
            "network",
            "network_discovery",
            "networkcontainer",
            "networktemplate",
            "networkuser",
            "networkview",
            "notification:rest:endpoint",
            "notification:rest:template",
            "notification:rule",
            "nsgroup",
            "nsgroup:delegation",
            "nsgroup:forwardingmember",
            "nsgroup:forwardstubserver",
            "nsgroup:stubmember",
            "orderedranges",
            "orderedresponsepolicyzones",
            "outbound:cloudclient",
            "parentalcontrol:avp",
            "parentalcontrol:blockingpolicy",
            "parentalcontrol:subscriber",
            "parentalcontrol:subscriberrecord",
            "parentalcontrol:subscribersite",
            "permission",
            "pxgrid:endpoint",
            "radius:authservice",
            "range",
            "rangetemplate",
            "record:a",
            "record:aaaa",
            "record:alias",
            "record:caa",
            "record:cname",
            "record:dhcid",
            "record:dname",
            "record:dnskey",
            "record:ds",
            "record:dtclbdn",
            "record:host",
            "record:host_ipv4addr",
            "record:host_ipv6addr",
            "record:mx",
            "record:naptr",
            "record:ns",
            "record:nsec",
            "record:nsec3",
            "record:nsec3param",
            "record:ptr",
            "record:rpz:a",
            "record:rpz:a:ipaddress",
            "record:rpz:aaaa",
            "record:rpz:aaaa:ipaddress",
            "record:rpz:cname",
            "record:rpz:cname:clientipaddress",
            "record:rpz:cname:clientipaddressdn",
            "record:rpz:cname:ipaddress",
            "record:rpz:cname:ipaddressdn",
            "record:rpz:mx",
            "record:rpz:naptr",
            "record:rpz:ptr",
            "record:rpz:srv",
            "record:rpz:txt",
            "record:rrsig",
            "record:srv",
            "record:tlsa",
            "record:txt",
            "record:unknown",
            "recordnamepolicy",
            "request",
            "restartservicestatus",
            "rir",
            "rir:organization",
            "roaminghost",
            "ruleset",
            "saml:authservice",
            "scavengingtask",
            "scheduledtask",
            "search",
            "sharednetwork",
            "sharedrecord:a",
            "sharedrecord:aaaa",
            "sharedrecord:cname",
            "sharedrecord:mx",
            "sharedrecord:srv",
            "sharedrecord:txt",
            "sharedrecordgroup",
            "smartfolder:children",
            "smartfolder:global",
            "smartfolder:personal",
            "snmpuser",
            "superhost",
            "superhostchild",
            "syslog:endpoint",
            "tacacsplus:authservice",
            "taxii",
            "tftpfiledir",
            "threatanalytics:analytics_whitelist",
            "threatanalytics:moduleset",
            "threatanalytics:whitelist",
            "threatinsight:cloudclient",
            "threatprotection:grid:rule",
            "threatprotection:profile",
            "threatprotection:profile:rule",
            "threatprotection:rule",
            "threatprotection:rulecategory",
            "threatprotection:ruleset",
            "threatprotection:ruletemplate",
            "threatprotection:statistics",
            "upgradegroup",
            "upgradeschedule",
            "upgradestatus",
            "userprofile",
            "vdiscoverytask",
            "view",
            "vlan",
            "vlanrange",
            "vlanview",
            "zone_auth",
            "zone_auth_discrepancy",
            "zone_delegated",
            "zone_forward",
            "zone_rp",
            "zone_stub"
        )][string] $Object,
        [int] $MaxResults,
        [switch] $FetchFromSchema,
        [string[]] $ReturnFields
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxObjects - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    if ($Objects) {
        Write-Verbose -Message "Get-InfobloxObjects - Requesting $Object"

        if ($FetchFromSchema) {
            $ReturnFields = Get-FieldsFromSchema -SchemaObject "$Object"
        }

        $invokeInfobloxQuerySplat = @{
            RelativeUri    = $Object.ToLower()
            Method         = 'GET'
            QueryParameter = @{
                _return_fields = $ReturnFields
            }
        }
        if ($MaxResults) {
            $invokeInfobloxQuerySplat.QueryParameter._max_results = $MaxResults
        }
        $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
        $Output | Select-ObjectByProperty -LastProperty '_ref'
    } else {
        foreach ($Ref in $ReferenceID) {
            Write-Verbose -Message "Get-InfobloxObjects - Requesting $Ref"
            if ($FetchFromSchema) {
                $ObjectType = $Ref.Split('/')[0]
                $ReturnFields = Get-FieldsFromSchema -SchemaObject "$ObjectType"
                if ($ReturnFields) {
                    Write-Verbose -Message "Get-InfobloxObjects - Requesting $ObjectType with fields $ReturnFields"
                } else {
                    Write-Warning -Message "Get-InfobloxObjects - Failed to get fields for $ObjectType"
                }
            }

            $invokeInfobloxQuerySplat = @{
                RelativeUri    = $Ref
                Method         = 'GET'
                QueryParameter = @{
                    _return_fields = $ReturnFields
                }
            }
            if ($MaxResults) {
                $invokeInfobloxQuerySplat.QueryParameter._max_results = $MaxResults
            }

            $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
            $Output | Select-ObjectByProperty -LastProperty '_ref'
        }
    }
}