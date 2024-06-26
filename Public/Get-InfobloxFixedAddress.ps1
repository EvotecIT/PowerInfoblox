﻿function Get-InfobloxFixedAddress {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][string] $MacAddress,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema,
        [string[]] $Properties
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxFixedAddress - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxFixedAddress - Requesting MacAddress [$MacAddress] / PartialMatch [$($PartialMatch.IsPresent)]"

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'fixedaddress'
        Method         = 'GET'
        QueryParameter = @{
            _max_results   = 1000000
            _return_fields = 'mac,ipv4addr,network_view'
        }
    }
    if ($FetchFromSchema) {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = Get-FieldsFromSchema -SchemaObject "fixedaddress"
    } elseif ($Properties) {
        $invokeInfobloxQuerySplat.QueryParameter._return_fields = $Properties -join ','
    }
    if ($PartialMatch) {
        $invokeInfobloxQuerySplat.QueryParameter."mac~" = $MacAddress.ToLower()
    } else {
        $invokeInfobloxQuerySplat.QueryParameter.mac = $MacAddress.ToLower()
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
}