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
    } else {
        if ($FetchFromSchema) {
            if (-not $Script:InfobloxSchemaFields) {
                $Script:InfobloxSchemaFields = [ordered] @{}
            }
            if ($Script:InfobloxSchemaFields["record:$Type"]) {
                $invokeInfobloxQuerySplat.QueryParameter._return_fields = ($Script:InfobloxSchemaFields["record:$Type"])
            } else {
                $Schema = Get-InfobloxSchema -Object "record:$Type"
                if ($Schema -and $Schema.fields.name) {
                    $invokeInfobloxQuerySplat.QueryParameter._return_fields = ($Schema.fields.Name -join ',')
                    $Script:InfobloxSchemaFields["record:$Type"] = ($Schema.fields.Name -join ',')
                } else {
                    Write-Warning -Message "Get-InfobloxDNSRecord - Failed to fetch schema for record type $($Type). Using defaults"
                }
            }
        } else {
            # will fetch defaults
        }
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
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Type -eq 'Host') {
        foreach ($Record in $Output) {
            [pscustomobject]@{
                name               = $Record.name
                dns_name           = $Record.dns_name
                aliases            = $Record.aliases
                dns_aliases        = $Record.dns_aliases
                view               = $Record.view
                configure_for_dns  = $Record.configure_for_dns
                configure_for_dhcp = $Record.ipv4addrs.configure_for_dhcp
                host               = $Record.ipv4addrs.host
                ipv4addr           = $Record.ipv4addrs.ipv4addr
                ipv4addr_ref       = $Record.ipv4addrs._ref
                _ref               = $Record._ref
            }
        }
    } else {
        $Output | Select-ObjectByProperty -LastProperty '_ref'
    }
}