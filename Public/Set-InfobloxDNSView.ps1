function Set-InfobloxDNSView {
    <#
    .SYNOPSIS
    Updates one DNS view.

    .DESCRIPTION
    Selects one view by Name or exact WAPI ReferenceID. Ambiguous or mismatched
    lookups list available references and skip the update.

    .PARAMETER Name
    The existing DNS view name.
    .PARAMETER ReferenceID
    The exact WAPI view reference.
    .PARAMETER Properties
    Nonempty WAPI field dictionary to update.
    .EXAMPLE
    Set-InfobloxDNSView -Name Internal -Properties @{ comment = 'Internal clients' } -WhatIf

    Previews changing the view comment.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [System.Collections.IDictionary] $Properties
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning 'Set-InfobloxDNSView - Connect to an Infoblox server first.'
        return
    }
    if ($Properties.Count -eq 0) { throw 'Set-InfobloxDNSView - Properties cannot be empty.' }
    $SelectSplat = @{ ObjectType = 'view'; CommandName = 'Set-InfobloxDNSView' }
    if ($PSCmdlet.ParameterSetName -eq 'ByReference') { $SelectSplat.ReferenceID = $ReferenceID }
    else { $SelectSplat.Name = $Name }
    $DNSView = Select-InfobloxDNSManagedObject @SelectSplat
    if (-not $DNSView) { return }
    if (-not $PSCmdlet.ShouldProcess($DNSView._ref, "Update DNS view fields: $(@($Properties.Keys) -join ', ')")) { return }
    Invoke-InfobloxQuery -RelativeUri $DNSView._ref -Method PUT -Body $Properties -Confirm:$false
}
