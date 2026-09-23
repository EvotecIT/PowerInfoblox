function Set-InfobloxDNSZone {
    <#
    .SYNOPSIS
    Updates an authoritative, forward, delegated, response policy, or stub DNS zone.

    .DESCRIPTION
    Updates one zone selected by its WAPI ReferenceID or by Type, Name, and optional
    View. Ambiguous or mismatched lookups list available references and skip the update.
    Supply the WAPI fields to change in Properties.

    .PARAMETER Type
    Authoritative, Forward, Delegated, ResponsePolicy, or Stub. Required when selecting by Name.
    .PARAMETER Name
    The existing zone FQDN.
    .PARAMETER View
    The existing DNS view used with Name.
    .PARAMETER ReferenceID
    The exact WAPI zone reference.
    .PARAMETER Properties
    Nonempty WAPI field dictionary to update.
    .EXAMPLE
    Set-InfobloxDNSZone -Type Authoritative -Name example.com -View Internal -Properties @{ comment = 'Managed zone' } -WhatIf

    Previews changing a zone after finding its exact reference.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [Parameter(ParameterSetName = 'ByReference')]
        [ValidateSet('Authoritative', 'Forward', 'Delegated', 'ResponsePolicy', 'Stub')]
        [string] $Type,

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $View,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [System.Collections.IDictionary] $Properties
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning 'Set-InfobloxDNSZone - Connect to an Infoblox server first.'
        return
    }
    if ($Properties.Count -eq 0) { throw 'Set-InfobloxDNSZone - Properties cannot be empty.' }
    $ObjectType = if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
        if ($ReferenceID -notmatch '^(zone_auth|zone_forward|zone_delegated|zone_rp|zone_stub)/') {
            throw "Set-InfobloxDNSZone - ReferenceID '$ReferenceID' is not a DNS zone reference."
        }
        $Matches[1]
    } else { Resolve-InfobloxDNSZoneType -Type $Type }
    if ($PSBoundParameters.ContainsKey('Type') -and (Resolve-InfobloxDNSZoneType -Type $Type) -ne $ObjectType) {
        throw "Set-InfobloxDNSZone - Type '$Type' does not match ReferenceID '$ReferenceID'."
    }
    $SelectSplat = @{ ObjectType = $ObjectType; CommandName = 'Set-InfobloxDNSZone' }
    if ($PSCmdlet.ParameterSetName -eq 'ByReference') { $SelectSplat.ReferenceID = $ReferenceID }
    else {
        $SelectSplat.Name = $Name
        if ($PSBoundParameters.ContainsKey('View')) { $SelectSplat.View = $View }
    }
    $Zone = Select-InfobloxDNSManagedObject @SelectSplat
    if (-not $Zone) { return }
    if (-not $PSCmdlet.ShouldProcess($Zone._ref, "Update DNS zone fields: $(@($Properties.Keys) -join ', ')")) { return }
    Invoke-InfobloxQuery -RelativeUri $Zone._ref -Method PUT -Body $Properties -Confirm:$false
}
