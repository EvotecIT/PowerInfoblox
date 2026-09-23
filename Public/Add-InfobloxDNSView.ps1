function Add-InfobloxDNSView {
    <#
    .SYNOPSIS
    Creates a DNS view.

    .DESCRIPTION
    Creates a WAPI view object. Name identifies the view. Supply optional Grid-specific
    fields through Properties.

    .PARAMETER Name
    The name of the new DNS view.

    .PARAMETER NetworkView
    The network view to associate with the DNS view.

    .PARAMETER Properties
    Additional WAPI view fields.

    .EXAMPLE
    Add-InfobloxDNSView -Name Internal -NetworkView default -WhatIf

    Previews creating a DNS view named Internal.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [ValidateNotNullOrEmpty()]
        [string] $NetworkView,

        [ValidateNotNull()]
        [System.Collections.IDictionary] $Properties
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning 'Add-InfobloxDNSView - Connect to an Infoblox server first.'
        return
    }
    $Body = [ordered]@{ name = $Name }
    if ($PSBoundParameters.ContainsKey('NetworkView')) {
        $Body.network_view = $NetworkView
    }
    if ($Properties) {
        foreach ($Entry in $Properties.GetEnumerator()) {
            if ($Entry.Key -ieq 'name' -and ([string] $Entry.Value) -ine $Name) {
                throw "Add-InfobloxDNSView - Properties.name does not match Name '$Name'."
            }
            if ($Entry.Key -ieq 'network_view' -and $PSBoundParameters.ContainsKey('NetworkView') -and ([string] $Entry.Value) -ine $NetworkView) {
                throw "Add-InfobloxDNSView - Properties.network_view does not match NetworkView '$NetworkView'."
            }
            $Body[$Entry.Key] = $Entry.Value
        }
    }
    if (-not $PSCmdlet.ShouldProcess($Name, 'Create DNS view')) {
        return
    }
    Invoke-InfobloxQuery -RelativeUri 'view' -Method POST -Body $Body -Confirm:$false
}
