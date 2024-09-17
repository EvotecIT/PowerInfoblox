function Get-InfobloxNetworkNextAvailableNetwork {
    <#
    .SYNOPSIS
    Get the next available network from a network container

    .DESCRIPTION
    Get the next available network from a network container

    .PARAMETER Network
    Provide the network container to search for the next available network

    .PARAMETER NetworkRef
    Provide the network container reference to search for the next available network (alternative to Network)

    .PARAMETER Quantity
    How many networks to return

    .PARAMETER Cidr
    The CIDR of the network to return

    .EXAMPLE
    Get-InfobloxNetworkNextAvailableNetwork -Network '10.2.0.0/16' -Quantity 5 -Cidr 27 -Verbose | Format-Table

    .NOTES
    General notes
    #>
    [cmdletbinding(DefaultParameterSetName = 'Network')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Network')][string] $Network,
        [Parameter(Mandatory, ParameterSetName = 'NetworkRef')][string] $NetworkRef,
        [Parameter()][alias('Count')][int] $Quantity = 1,
        [Parameter(Mandatory)][int] $Cidr
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxNetworkNextAvailableNetwork - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($Network) {
        $NetworkInformation = Get-InfobloxNetworkContainer -Network $Network
        if ($NetworkInformation) {
            $NetworkRef = $NetworkInformation._ref
        } else {
            Write-Warning -Message "Get-InfobloxNetworkNextAvailableNetwork - No network container found for [$Network]"
            return
        }
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = $NetworkRef
        QueryParameter = @{
            _function = 'next_available_network'
            cidr      = $Cidr
            num       = $Quantity
        }
        Method         = 'POST'
    }
    $Query = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WarningAction SilentlyContinue -WarningVariable varWarning -WhatIf:$false
    if ($Query) {
        $Query.networks
    } else {
        Write-Warning -Message "Get-InfobloxNetworkNextAvailableNetwork - No network returned for network container [$NetworkRef], error: $varWarning"
    }
}