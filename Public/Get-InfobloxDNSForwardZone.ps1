function Get-InfobloxDNSForwardZone {
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
        $invokeInfobloxQuerySplat.QueryParameter.fqdn = $Name.ToLower()
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat | Select-ObjectByProperty -LastProperty '_ref'
}