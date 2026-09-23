function Remove-InfobloxDNSZone {
    <#
    .SYNOPSIS
    Removes one authoritative, forward, or delegated DNS zone.

    .DESCRIPTION
    Selects one zone by exact WAPI ReferenceID or by Type, Name, and optional View.
    Ambiguous or mismatched lookups list available references and skip removal.

    .PARAMETER Type
    Authoritative, Forward, or Delegated. Required when selecting by Name.
    .PARAMETER Name
    The existing zone FQDN.
    .PARAMETER View
    The existing DNS view used with Name.
    .PARAMETER ReferenceID
    The exact zone_auth, zone_forward, or zone_delegated WAPI reference.
    .EXAMPLE
    Remove-InfobloxDNSZone -Type Forward -Name example.com -View Internal -WhatIf

    Previews removing one forward zone.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [Parameter(ParameterSetName = 'ByReference')]
        [ValidateSet('Authoritative', 'Forward', 'Delegated')]
        [string] $Type,

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $View,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning 'Remove-InfobloxDNSZone - Connect to an Infoblox server first.'
        return
    }
    $ObjectType = if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
        if ($ReferenceID -notmatch '^(zone_auth|zone_forward|zone_delegated)/') {
            throw "Remove-InfobloxDNSZone - ReferenceID '$ReferenceID' is not a DNS zone reference."
        }
        $Matches[1]
    } else { Resolve-InfobloxDNSZoneType -Type $Type }
    if ($PSBoundParameters.ContainsKey('Type') -and (Resolve-InfobloxDNSZoneType -Type $Type) -ne $ObjectType) {
        throw "Remove-InfobloxDNSZone - Type '$Type' does not match ReferenceID '$ReferenceID'."
    }
    $SelectSplat = @{ ObjectType = $ObjectType; CommandName = 'Remove-InfobloxDNSZone' }
    if ($PSCmdlet.ParameterSetName -eq 'ByReference') { $SelectSplat.ReferenceID = $ReferenceID }
    else {
        $SelectSplat.Name = $Name
        if ($PSBoundParameters.ContainsKey('View')) { $SelectSplat.View = $View }
    }
    $Zone = Select-InfobloxDNSManagedObject @SelectSplat
    if (-not $Zone) { return }
    if (-not $PSCmdlet.ShouldProcess($Zone._ref, 'Remove DNS zone')) { return }
    Invoke-InfobloxQuery -RelativeUri $Zone._ref -Method DELETE -Confirm:$false
}
