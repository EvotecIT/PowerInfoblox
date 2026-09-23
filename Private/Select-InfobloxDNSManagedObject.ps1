function Select-InfobloxDNSManagedObject {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('view', 'zone_auth', 'zone_forward', 'zone_delegated')]
        [string] $ObjectType,

        [Parameter(Mandatory)]
        [string] $CommandName,

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [string] $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [string] $View,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [string] $ReferenceID
    )

    $FindSplat = @{ ObjectType = $ObjectType }
    if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
        $FindSplat.ReferenceID = $ReferenceID
    } else {
        $FindSplat.Name = $Name
        if ($PSBoundParameters.ContainsKey('View')) { $FindSplat.View = $View }
    }
    $Result = Find-InfobloxDNSManagedObject @FindSplat
    [Array] $Candidates = $Result.Candidates
    [Array] $Selected = $Result.Selected
    if ($Selected.Count -ne 1) {
        $Identity = if ($PSCmdlet.ParameterSetName -eq 'ByReference') { $ReferenceID } else { $Name }
        $Reason = if ($Selected.Count -eq 0 -and $Candidates.Count -gt 0) {
            "No $ObjectType object matches the requested name and view."
        } else {
            "Found $($Selected.Count) matching $ObjectType objects for '$Identity'."
        }
        $Details = Format-InfobloxDNSManagedObjectCandidate -Records $Candidates -ObjectType $ObjectType
        Write-Warning "$CommandName - $Reason Available objects:`n$Details`nUse ReferenceID to select one object. Skipping."
        return
    }
    if (-not $Selected[0]._ref -or -not ([string] $Selected[0]._ref).StartsWith("$ObjectType/", [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Warning "$CommandName - Selected $ObjectType object has no matching WAPI reference. Skipping."
        return
    }
    $Selected[0]
}
