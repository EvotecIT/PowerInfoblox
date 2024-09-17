function Get-InfobloxNetworkContainer {
    <#
    .SYNOPSIS
    Get Infoblox Network Containers

    .DESCRIPTION
    Get Infoblox Network Containers

    .PARAMETER Network
    Provide the network to search for network containers

    .PARAMETER PartialMatch
    Allow partial matches

    .PARAMETER FetchFromSchema
    Fetch fields from schema. By default, only the _ref field is returned

    .PARAMETER MaxResults
    Maximum number of results to return

    .EXAMPLE
    Get-InfoBloxNetworkContainer -Network '10.2.0.0/16' -Verbose | Format-Table

    .EXAMPLE
    Get-InfoBloxNetworkContainer -Network '10.2' -Verbose -PartialMatch | Format-Table

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $Network,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema,
        [int] $MaxResults = 1000000
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxNetworkContainer - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    if ($Network) {
        Write-Verbose -Message "Get-InfobloxNetworkContainer - Requesting Network Containers for Network [$Network] / PartialMatch [$($PartialMatch.IsPresent)]"
    } else {
        Write-Verbose -Message "Get-InfobloxNetworkContainer - Requesting Network Containers for all networks"
    }

    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "networkcontainer"
    } else {
        $ReturnFields = $Null
    }
    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'networkcontainer'
        Method         = 'GET'
        QueryParameter = @{
            _max_results   = $MaxResults
            _return_fields = $ReturnFields
        }
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