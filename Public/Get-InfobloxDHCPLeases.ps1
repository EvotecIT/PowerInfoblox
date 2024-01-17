function Get-InfobloxDHCPLeases {
    [CmdletBinding()]
    param(
        [string] $Network,
        [string] $IPv4Address,
        [string] $Hostname,
        [switch] $PartialMatch
    )
    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxDHCPLeases - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxDHCPLeases - Requesting DHCP leases for Network [$Network] / IPv4Address [$IPv4Address] / Hostname [$Hostname] / PartialMatch [$($PartialMatch.IsPresent)]"

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'lease'
        Method         = 'GET'
        QueryParameter = @{
            _return_fields = 'binding_state,hardware,client_hostname,fingerprint,address,network_view'
            _max_results = 1000000
        }
    }
    if ($Network) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."network~" = $Network.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.network = $Network.ToLower()
        }
    }
    if ($IPv4Address) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."ipv4addr~" = $IPv4Address.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.ipv4addr = $IPv4Address.ToLower()
        }
    }
    if ($Hostname) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."name~" = $Hostname.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.name = $Hostname.ToLower()
        }
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat
}