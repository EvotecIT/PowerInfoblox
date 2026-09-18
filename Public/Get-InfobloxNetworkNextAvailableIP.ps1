function Get-InfobloxNetworkNextAvailableIP {
    <#
    .SYNOPSIS
    Gets the next available IPv4 addresses from an Infoblox network.

    .DESCRIPTION
    Calls the Infoblox WAPI next_available_ip function for a network selected by
    CIDR value or object reference.

    .PARAMETER Network
    Specifies the IPv4 network in CIDR notation. The command resolves it to an object reference.

    .PARAMETER NetworkRef
    Specifies an Infoblox network object reference, such as network/ZG5zLm5ldHdvcmsu...

    .PARAMETER Quantity
    Specifies how many available addresses to return. The default is 1. Count is an alias.

    .EXAMPLE
    Get-InfobloxNetworkNextAvailableIP -Network '192.0.2.0/24'

    Returns one available address from the specified network.

    .EXAMPLE
    Get-InfobloxNetworkNextAvailableIP -NetworkRef 'network/ZG5zLm5ldHdvcmsu...' -Count 3

    Returns three available addresses using a network object reference.
    #>
    [cmdletbinding(DefaultParameterSetName = 'Network')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Network')][string] $Network,
        [Parameter(Mandatory, ParameterSetName = 'NetworkRef')][string] $NetworkRef,
        [alias('Count')][int] $Quantity = 1
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
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

    $Query = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WarningAction SilentlyContinue -WarningVariable varWarning -WhatIf:$false
    if ($Query) {
        $Query.ips
    } else {
        Write-Warning -Message "Get-InfobloxNetworkNextAvailableIP - No IP returned for network [$NetworkRef], error: $varWarning"
    }
}
