function Get-InfobloxDHCPRange {
    [CmdletBinding()]
    param(
        [string] $Network,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema
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
    } else {
        $ReturnFields = $Null
    }
    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'range'
        Method         = 'GET'
        QueryParameter = @{
            _max_results   = 1000000
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