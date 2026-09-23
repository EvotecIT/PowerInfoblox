function Get-InfobloxDNSStubZone {
    <#
    .SYNOPSIS
    Retrieves DNS stub zones.

    .DESCRIPTION
    Queries Infoblox WAPI zone_stub objects. Results can be filtered by zone
    FQDN and DNS view.

    .PARAMETER FQDN
    Filters stub zones by fully qualified domain name.
    .PARAMETER View
    Filters stub zones by DNS view name.
    .PARAMETER FetchFromSchema
    Requests every readable zone_stub field advertised by the connected WAPI schema.
    .EXAMPLE
    Get-InfobloxDNSStubZone -FQDN example.com -View Internal

    Returns the stub zone and its WAPI reference.
    #>
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string] $FQDN,

        [ValidateNotNullOrEmpty()]
        [string] $View,

        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning 'Get-InfobloxDNSStubZone - Connect to an Infoblox server first.'
        return
    }
    $QueryParameter = @{ _max_results = 1000000 }
    if ($PSBoundParameters.ContainsKey('FQDN')) { $QueryParameter.fqdn = Normalize-InfobloxDNSZoneName -Name $FQDN }
    if ($PSBoundParameters.ContainsKey('View')) { $QueryParameter.view = $View }
    $PreferredFields = if ($FetchFromSchema) { $null } else { @('fqdn', 'view', 'comment', 'disable', 'stub_from', 'stub_members') }
    $ReturnFields = Get-FieldsFromSchema -SchemaObject 'zone_stub' -RequestedFields $PreferredFields
    if ($ReturnFields) { $QueryParameter._return_fields = $ReturnFields }
    Invoke-InfobloxQuery -RelativeUri 'zone_stub' -Method GET -QueryParameter $QueryParameter -WhatIf:$false
}
