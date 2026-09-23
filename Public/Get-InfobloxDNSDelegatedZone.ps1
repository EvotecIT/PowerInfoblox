function Get-InfobloxDNSDelegatedZone {
    <#
    .SYNOPSIS
    Retrieves delegated DNS zones from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI zone_delegated objects. Results can be filtered by zone
    name and DNS view.

    .PARAMETER Name
    Filters delegated zones by fully qualified domain name.

    .PARAMETER View
    Filters delegated zones by DNS view name.

    .EXAMPLE
    Get-InfobloxDNSDelegatedZone -Name 'delegated.example.com' -View 'default'

    Returns the delegated zone from the default DNS view.
    #>
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
            _return_fields = Get-FieldsFromSchema -SchemaObject 'zone_delegated' -RequestedFields ('address,comment,delegate_to,delegated_ttl,disable,display_domain,dns_fqdn,enable_rfc2317_exclusion,extattrs,fqdn,locked,locked_by,mask_prefix,ms_ad_integrated,ms_ddns_mode,ms_managed,ms_read_only,ms_sync_master_name,ns_group,parent,prefix,use_delegated_ttl,using_srg_associations,view,zone_format' -split ',')
        }
    }
    if ($View) {
        $invokeInfobloxQuerySplat.QueryParameter.view = $View.ToLower()
    }
    if ($Name) {
        $invokeInfobloxQuerySplat.QueryParameter.fqdn = Normalize-InfobloxDNSZoneName -Name $Name
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false | Select-ObjectByProperty -LastProperty '_ref'
}
