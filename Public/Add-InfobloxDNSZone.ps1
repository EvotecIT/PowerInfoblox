function Add-InfobloxDNSZone {
    <#
    .SYNOPSIS
    Creates an authoritative, forward, delegated, response policy, or stub DNS zone.

    .DESCRIPTION
    Creates a zone_auth, zone_forward, zone_delegated, zone_rp, or zone_stub WAPI object. Name becomes the
    fqdn field. Supply the remaining WAPI fields in Properties, such as grid_primary,
    forward_to, delegate_to, substitute_name, or stub_from, according to the connected Grid's schema.

    .PARAMETER Type
    The zone kind: Authoritative, Forward, Delegated, ResponsePolicy, or Stub.

    .PARAMETER Name
    The zone's fully qualified domain name.

    .PARAMETER View
    The DNS view. When omitted, WAPI chooses its default.

    .PARAMETER Properties
    Additional WAPI fields needed for the zone kind and Grid configuration.

    .EXAMPLE
    Add-InfobloxDNSZone -Type Authoritative -Name 'example.com' -View Internal -WhatIf

    Previews creating an authoritative zone in the Internal view.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Authoritative', 'Forward', 'Delegated', 'ResponsePolicy', 'Stub')]
        [string] $Type,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [ValidateNotNullOrEmpty()]
        [string] $View,

        [ValidateNotNull()]
        [System.Collections.IDictionary] $Properties
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning 'Add-InfobloxDNSZone - Connect to an Infoblox server first.'
        return
    }
    $ObjectType = Resolve-InfobloxDNSZoneType -Type $Type
    $Body = [ordered]@{ fqdn = $Name }
    if ($PSBoundParameters.ContainsKey('View')) {
        $Body.view = $View
    }
    if ($Properties) {
        foreach ($Entry in $Properties.GetEnumerator()) {
            if ($Entry.Key -ieq 'fqdn' -and ([string] $Entry.Value).TrimEnd('.') -ine $Name.TrimEnd('.')) {
                throw "Add-InfobloxDNSZone - Properties.fqdn does not match Name '$Name'."
            }
            if ($Entry.Key -ieq 'view' -and $PSBoundParameters.ContainsKey('View') -and ([string] $Entry.Value) -ine $View) {
                throw "Add-InfobloxDNSZone - Properties.view does not match View '$View'."
            }
            $Body[$Entry.Key] = $Entry.Value
        }
    }
    if (-not $PSCmdlet.ShouldProcess("$Name ($Type zone)", 'Create DNS zone')) {
        return
    }
    Invoke-InfobloxQuery -RelativeUri $ObjectType -Method POST -Body $Body -Confirm:$false
}
