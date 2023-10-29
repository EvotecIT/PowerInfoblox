﻿function Get-InfoBloxSearch {
    [CmdletBinding()]
    param(
        [parameter(ParameterSetName = 'IPv4')][string] $IPv4Address
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfoBloxSearch - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    Write-Verbose -Message "Get-InfoBloxSearch - Requesting IPv4Address [$IPv4Address]"

    $invokeInfobloxQuerySplat = [ordered]@{
        RelativeUri    = 'search'
        Method         = 'GET'
        QueryParameter = [ordered]@{

        }
    }
    if ($IPv4Address) {
        $invokeInfobloxQuerySplat.QueryParameter.address = $IPv4Address
    }

    Invoke-InfobloxQuery @invokeInfobloxQuerySplat
}