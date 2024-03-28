function Get-InfobloxDNSRecord {
    [alias('Get-InfobloxDNSRecords')]
    [cmdletbinding()]
    param(
        [string] $Name,
        [string] $Zone,
        [string] $View,
        [switch] $PartialMatch,
        [ValidateSet(
            'A', 'AAAA', 'CName', 'DName',
            'DNSKEY', 'DS', 'Host', 'host_ipv4addr', 'host_ipv6addr',
            'LBDN', 'MX', 'NAPTR', 'NS', 'NSEC',
            'NSEC3', 'NSEC3PARAM', 'PTR', 'RRSIG', 'SRV', 'TXT'
        )]
        [string] $Type = 'Host',
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSRecord - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = "record:$($Type.ToLower())"
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
        }
    }
    if ($Type -eq 'Host') {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = 'name,dns_name,aliases,dns_aliases,ipv4addrs,configure_for_dns,view'
    } elseif ($Type -eq 'PTR') {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = 'aws_rte53_record_info,cloud_info,comment,creation_time,creator,ddns_principal,ddns_protected,disable,discovered_data,dns_name,dns_ptrdname,extattrs,forbid_reclamation,ipv4addr,ipv6addr,last_queried,ms_ad_user_data,name,ptrdname,reclaimable,shared_record_group,ttl,use_ttl,view,zone'
    } elseif ($Type -eq 'A') {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = 'ipv4addr,name,view,zone,cloud_info,comment,creation_time,creator,ddns_principal,ddns_protected,disable,discovered_data,dns_name,last_queried,ms_ad_user_data,reclaimable,shared_record_group,ttl,use_ttl'
    }
    if ($FetchFromSchema) {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = Get-FieldsFromSchema -SchemaObject "record:$Type"
    }
    if ($Zone) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."zone~" = $Zone.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.zone = $Zone.ToLower()
        }
    }
    if ($View) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."view~" = $View.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.view = $View.ToLower()
        }
    }
    if ($Name) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."name~" = $Name.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.name = $Name.ToLower()
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    if ($Type -eq 'A') {
        $Output | Select-ObjectByProperty -LastProperty '_ref' -FirstProperty 'name', 'ipv4addr', 'view', 'zone', 'cloud_info', 'comment', 'creation_time', 'creator', 'ddns_principal', 'ddns_protected', 'disable', 'discovered_data', 'dns_name', 'last_queried', 'ms_ad_user_data', 'reclaimable', 'shared_record_group', 'ttl', 'use_ttl'
    } elseif ($Type -eq 'HOST') {
        $Output | Select-ObjectByProperty -LastProperty '_ref' -FirstProperty 'name', 'dns_name', 'aliases', 'dns_aliases', 'view', 'configure_for_dns', 'configure_for_dhcp', 'host', 'ipv4addr', 'ipv4addr_ref'
    } else {
        $Output | Select-ObjectByProperty -LastProperty '_ref'
    }
}