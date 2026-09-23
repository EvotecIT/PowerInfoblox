function Remove-InfobloxDNSView {
    <#
    .SYNOPSIS
    Removes one DNS view.

    .DESCRIPTION
    Selects one view by Name or exact WAPI ReferenceID. Ambiguous or mismatched
    lookups list available references and skip removal. The default view cannot
    be removed.

    .PARAMETER Name
    The existing DNS view name.
    .PARAMETER ReferenceID
    The exact WAPI view reference.
    .EXAMPLE
    Remove-InfobloxDNSView -Name Internal -WhatIf

    Previews removing the Internal view.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning 'Remove-InfobloxDNSView - Connect to an Infoblox server first.'
        return
    }
    $SelectSplat = @{ ObjectType = 'view'; CommandName = 'Remove-InfobloxDNSView' }
    if ($PSCmdlet.ParameterSetName -eq 'ByReference') { $SelectSplat.ReferenceID = $ReferenceID }
    else { $SelectSplat.Name = $Name }
    $DNSView = Select-InfobloxDNSManagedObject @SelectSplat
    if (-not $DNSView) { return }
    if ($DNSView.is_default -eq $true) {
        Write-Warning "Remove-InfobloxDNSView - '$($DNSView._ref)' is the default DNS view. Skipping."
        return
    }
    if ($null -eq $DNSView.is_default) {
        Write-Warning "Remove-InfobloxDNSView - Cannot determine whether '$($DNSView._ref)' is the default DNS view. Skipping."
        return
    }
    if (-not $PSCmdlet.ShouldProcess($DNSView._ref, 'Remove DNS view')) { return }
    Invoke-InfobloxQuery -RelativeUri $DNSView._ref -Method DELETE -Confirm:$false
}
