function Get-InfobloxDHCP {
    [CmdletBinding()]
    param(
        [string] $Network,
        [switch] $PartialMatch
    )
    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxDHCP - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    if ($Network) {
        Write-Verbose -Message "Get-InfobloxDHCP - Requesting DHCP ranges for Network [$Network] / PartialMatch [$($PartialMatch.IsPresent)]"
    } else {
        Write-Verbose -Message "Get-InfobloxDHCP - Requesting DHCP ranges for all networks"
    }
    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'range'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            # _return_fields = 'mac,ipv4addr,network_view'
        }
    }
    if ($Network) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."network~" = $Network.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.network = $Network.ToLower()
        }
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat
}