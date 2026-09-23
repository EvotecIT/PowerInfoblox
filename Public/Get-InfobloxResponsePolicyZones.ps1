function Get-InfobloxResponsePolicyZones {
    <#
    .SYNOPSIS
    Retrieves response policy zones from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI zone_rp objects available to the connected account.
    Results can be filtered by zone FQDN and DNS view.

    .PARAMETER FQDN
    Filters response policy zones by fully qualified domain name.

    .PARAMETER View
    Filters response policy zones by DNS view name.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the zone_rp object by the connected WAPI schema.

    .EXAMPLE
    Get-InfobloxResponsePolicyZones

    Returns response policy zones using the default WAPI fields.

    .EXAMPLE
    Get-InfobloxResponsePolicyZones -FQDN example.com -View Internal -FetchFromSchema

    Returns the matching response policy zone with all readable fields advertised by the connected WAPI schema.
    #>
    [cmdletbinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string] $FQDN,

        [ValidateNotNullOrEmpty()]
        [string] $View,

        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxResponsePolicyZones - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $QueryParameter = @{ _max_results = 1000000 }
    if ($PSBoundParameters.ContainsKey('FQDN')) { $QueryParameter.fqdn = Normalize-InfobloxDNSZoneName -Name $FQDN }
    if ($PSBoundParameters.ContainsKey('View')) { $QueryParameter.view = $View }
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "zone_rp"
    } else {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject 'zone_rp' -RequestedFields @('fqdn', 'view', 'comment', 'disable', 'rpz_policy', 'rpz_priority')
    }
    if ($ReturnFields) { $QueryParameter._return_fields = $ReturnFields }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'zone_rp'
        Method         = 'GET'
        QueryParameter = $QueryParameter
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}
