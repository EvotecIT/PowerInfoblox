function Get-InfobloxNetworkNextAvailableIP {
    [cmdletbinding(DefaultParameterSetName = 'Network')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Network')][string] $Network,
        [Parameter(Mandatory, ParameterSetName = 'NetworkRef')][string] $NetworkRef,
        [alias('Count')][int] $Quantity = 1
    )
    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxNetworkNextAvailableIP - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($Network) {
        $NetworkInformation = Get-InfobloxNetwork -Network $Network
        if ($NetworkInformation) {
            $NetworkRef = $NetworkInformation.NetworkRef
        } else {
            Write-Warning -Message "Get-InfobloxNetworkNextAvailableIP - No network found for [$Network]"
            return
        }
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = $NetworkRef
        QueryParameter = @{
            _function = 'next_available_ip'
            num       = $Quantity
        }
        Method         = 'POST'
    }

    $Query = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WarningAction SilentlyContinue -WarningVariable varWarning
    if ($Query) {
        $Query.ips
    } else {
        Write-Warning -Message "Get-InfobloxNetworkNextAvailableIP - No IP returned for network [$NetworkRef], error: $varWarning"
    }
}