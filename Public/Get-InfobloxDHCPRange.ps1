function Get-InfobloxDHCPRange {
    <#
    .SYNOPSIS
    Retrieves DHCP range configuration from an Infoblox server.

    .DESCRIPTION
    This function retrieves the DHCP range configuration from an Infoblox server. It allows filtering by ReferenceID, Network, and other parameters.

    .PARAMETER ReferenceID
    The unique identifier for the DHCP range to be retrieved.

    .PARAMETER Network
    The network for which to retrieve DHCP ranges.

    .PARAMETER PartialMatch
    Indicates whether to perform a partial match on the network.

    .PARAMETER FetchFromSchema
    Indicates whether to fetch return fields from the schema.

    .PARAMETER ReturnFields
    An array of fields to be returned in the response.

    .PARAMETER MaxResults
    The maximum number of results to return. Default is 1,000,000.

    .EXAMPLE
    Get-InfobloxDHCPRange -ReferenceID 'DHCPRange-1'

    .EXAMPLE
    Get-InfobloxDHCPRange -Network '192.168.1' -PartialMatch

    .EXAMPLE
    Get-InfobloxDHCPRange -Network '192.168.1.0/24' -FetchFromSchema

    .NOTES
    Ensure you are connected to an Infoblox server using Connect-Infoblox before running this function.
    #>
    [CmdletBinding()]
    param(
        [string] $ReferenceID,
        [string] $Network,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema,
        [string[]] $ReturnFields,
        [int] $MaxResults = 1000000
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDHCPRange - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    if ($Network) {
        Write-Verbose -Message "Get-InfobloxDHCPRange - Requesting DHCP ranges for Network [$Network] / PartialMatch [$($PartialMatch.IsPresent)]"
    } else {
        Write-Verbose -Message "Get-InfobloxDHCPRange - Requesting DHCP ranges for all networks"
    }

    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "range"
    } elseif ($ReturnFields) {
        $ReturnFields = ($ReturnFields | Sort-Object -Unique) -join ','
    } else {
        $ReturnFields = $Null
    }
    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'range'
        Method         = 'GET'
        QueryParameter = @{
            _max_results   = $MaxResults
            _return_fields = $ReturnFields
        }
    }
    if ($ReferenceID) {
        $invokeInfobloxQuerySplat.RelativeUri = $ReferenceID
    }
    if ($Network) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."network~" = $Network.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.network = $Network.ToLower()
        }
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
}