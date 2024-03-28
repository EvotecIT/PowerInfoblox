function Get-InfobloxDNSDelegatedZone {
    [cmdletbinding()]
    param(
        [string] $Name,
        [string] $View
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSDelgatedZone - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'zone_delegated'
        Method         = 'GET'
        QueryParameter = @{
            _max_results   = 1000000
            _return_fields = "address,comment,delegate_to,delegated_ttl,disable,display_domain,dns_fqdn,enable_rfc2317_exclusion,extattrs,fqdn,locked,locked_by,mask_prefix,ms_ad_integrated,ms_ddns_mode,ms_managed,ms_read_only,ms_sync_master_name,ns_group,parent,prefix,use_delegated_ttl,using_srg_associations,view,zone_format"
        }
    }
    if ($View) {
        $invokeInfobloxQuerySplat.QueryParameter.view = $View.ToLower()
    }
    if ($Name) {
        $invokeInfobloxQuerySplat.QueryParameter.fqdn = $Name.ToLower()
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false | Select-ObjectByProperty -LastProperty '_ref'
}