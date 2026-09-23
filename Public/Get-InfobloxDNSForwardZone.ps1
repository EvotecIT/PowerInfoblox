function Get-InfobloxDNSForwardZone {
    <#
    .SYNOPSIS
    Retrieves forward DNS zones from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI zone_forward objects. Results can be filtered by zone
    name and DNS view.

    .PARAMETER Name
    Filters forward zones by fully qualified domain name.

    .PARAMETER View
    Filters forward zones by DNS view name.

    .EXAMPLE
    Get-InfobloxDNSForwardZone -Name 'branch.example.com' -View 'default'

    Returns the forward zone from the default DNS view.
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
        Write-Warning -Message 'Get-InfobloxDNSForwardZone - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'zone_forward'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
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
