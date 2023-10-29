﻿function Get-InfobloxDNSRecords {
    [cmdletbinding()]
    param(
        [string] $Name,
        [string] $Zone,
        [string] $View,
        [switch] $PartialMatch,
        [ValidateSet(
            'A', 'AAAA', 'CName', 'DName',
            'DNSKEY', 'DS', 'Host', 'LBDN', 'MX', 'NAPTR', 'NS', 'NSEC',
            'NSEC3', 'NSEC3PARAM', 'PTR', 'RRSIG', 'SRV', 'TXT'
        )]
        [string]$Type = 'Host'
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxDNSAuthZones - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = "record:$($Type.ToLower())"
        Method         = 'GET'
        QueryParameter = @{

        }
    }
    if ($Type -eq 'Host') {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = 'name,dns_name,aliases,dns_aliases,ipv4addrs,configure_for_dns,view'
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
    foreach ($Record in $Output) {
        if ($Type -eq 'Host') {
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
        } else {
            $Record
        }
    }
}