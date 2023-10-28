﻿function Get-InfobloxFixedAddress {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][string] $MacAddress,
        [switch] $PartialMatch
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxFixedAddress - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxFixedAddress - Requesting MacAddress [$MacAddress] / PartialMatch [$($PartialMatch.IsPresent)]"

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'fixedaddress'
        Method         = 'GET'
        QueryParameter = @{
            _return_fields = 'mac,ipv4addr,network_view'
        }
    }
    if ($PartialMatch) {
        $invokeInfobloxQuerySplat.QueryParameter."mac~" = $MacAddress.ToLower()
    } else {
        $invokeInfobloxQuerySplat.QueryParameter.mac = $MacAddress.ToLower()
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat
}