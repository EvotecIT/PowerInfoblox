function Get-InfobloxDNSView {
    <#
    .SYNOPSIS
    Retrieves DNS views from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI view objects and returns the DNS views available to the
    current connection. Use Name or ReferenceID to inspect one view before
    changing or removing it.

    .PARAMETER Name
    Filters views by exact name.

    .PARAMETER ReferenceID
    Retrieves a view by its exact WAPI reference.

    .EXAMPLE
    Get-InfobloxDNSView

    Returns all DNS views available to the connected account.

    .EXAMPLE
    Get-InfobloxDNSView -Name Internal

    Lists the Internal view and its WAPI reference.
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSView - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxDNSView - Requesting DNS View"

    if ($PSCmdlet.ParameterSetName -eq 'ByReference' -and
        -not $ReferenceID.StartsWith('view/', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Get-InfobloxDNSView - ReferenceID '$ReferenceID' is not a DNS view reference."
    }
    $QueryParameter = @{}
    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        $QueryParameter._max_results = 1000000
        if ($PSBoundParameters.ContainsKey('Name')) { $QueryParameter.name = $Name }
    }
    $ReturnFields = Get-FieldsFromSchema -SchemaObject 'view' -RequestedFields @('name', 'is_default', 'network_view', 'comment')
    if ($ReturnFields) { $QueryParameter._return_fields = $ReturnFields }
    $invokeInfobloxQuerySplat = @{
        RelativeUri    = if ($PSCmdlet.ParameterSetName -eq 'ByReference') { $ReferenceID } else { 'view' }
        Method         = 'GET'
        QueryParameter = $QueryParameter
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
}
