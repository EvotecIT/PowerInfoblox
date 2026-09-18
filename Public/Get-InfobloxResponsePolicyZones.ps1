function Get-InfobloxResponsePolicyZones {
    <#
    .SYNOPSIS
    Retrieves response policy zones from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI zone_rp objects available to the connected account.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the zone_rp object by the connected WAPI schema.

    .EXAMPLE
    Get-InfobloxResponsePolicyZones

    Returns response policy zones using the default WAPI fields.

    .EXAMPLE
    Get-InfobloxResponsePolicyZones -FetchFromSchema

    Returns response policy zones with all fields advertised by the connected WAPI schema.
    #>
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxResponsePolicyZones - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # defalt return fields
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "zone_rp"
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'zone_rp'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}
