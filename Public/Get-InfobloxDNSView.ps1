function Get-InfobloxDNSView {
    <#
    .SYNOPSIS
    Retrieves DNS views from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI view objects and returns the DNS views available to the
    current connection.

    .EXAMPLE
    Get-InfobloxDNSView

    Returns all DNS views available to the connected account.
    #>
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
        }
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
}
