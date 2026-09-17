function Get-InfobloxFixedAddress {
    <#
    .SYNOPSIS
    Retrieves fixed IPv4 address assignments by MAC address.

    .DESCRIPTION
    Queries Infoblox WAPI fixedaddress objects for an exact or partial MAC address
    match. By default, the result includes the MAC address, IPv4 address, network
    view, and object reference.

    .PARAMETER MacAddress
    Specifies the MAC address to find.

    .PARAMETER PartialMatch
    Uses partial matching instead of an exact MAC address match.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the fixedaddress object by the connected WAPI schema.

    .PARAMETER Properties
    Specifies the fixedaddress fields to return instead of the default fields.

    .EXAMPLE
    Get-InfobloxFixedAddress -MacAddress '00:11:22:33:44:55'

    Returns fixed address assignments for the exact MAC address.

    .EXAMPLE
    Get-InfobloxFixedAddress -MacAddress '00:11:22' -PartialMatch -Properties mac,ipv4addr,comment

    Returns partially matching assignments and limits the returned fields.
    #>
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
            _return_fields = Get-FieldsFromSchema -SchemaObject 'fixedaddress' -RequestedFields @('mac', 'ipv4addr', 'network_view')
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
