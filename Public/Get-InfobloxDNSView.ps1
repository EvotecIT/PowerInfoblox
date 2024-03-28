function Get-InfobloxDNSView {
    [cmdletbinding()]
    param(

    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSView - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxDNSView - Requesting DNS View"

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'view'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            # _return_fields = 'mac,ipv4addr,network_view'
        }
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
}