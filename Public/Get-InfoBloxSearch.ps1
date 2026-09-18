function Get-InfoBloxSearch {
    <#
    .SYNOPSIS
    Searches Infoblox objects by IPv4 address.

    .DESCRIPTION
    Queries the Infoblox WAPI search endpoint. When IPv4Address is omitted, the
    endpoint is queried without an address filter.

    .PARAMETER IPv4Address
    Filters search results by IPv4 address.

    .EXAMPLE
    Get-InfoBloxSearch -IPv4Address '192.0.2.15'

    Returns Infoblox search results associated with the specified address.
    #>
    [CmdletBinding()]
    param(
        [parameter(ParameterSetName = 'IPv4')][string] $IPv4Address
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfoBloxSearch - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    Write-Verbose -Message "Get-InfoBloxSearch - Requesting IPv4Address [$IPv4Address]"

    $invokeInfobloxQuerySplat = [ordered]@{
        RelativeUri    = 'search'
        Method         = 'GET'
        QueryParameter = [ordered]@{
            _max_results = 1000000
        }
    }
    if ($IPv4Address) {
        $invokeInfobloxQuerySplat.QueryParameter.address = $IPv4Address
    }

    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
}
