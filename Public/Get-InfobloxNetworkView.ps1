function Get-InfobloxNetworkView {
    [cmdletbinding()]
    param(

    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxNetworkView - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxNetworkView - Requesting Network View"

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'networkview'
        Method         = 'GET'
        QueryParameter = @{
            # _return_fields = 'mac,ipv4addr,network_view'
        }
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat
}