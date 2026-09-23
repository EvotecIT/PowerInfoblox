function Find-InfobloxDNSRecordCandidate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Type,

        [string] $View,

        [ValidateNotNullOrEmpty()]
        [string] $MatchValue
    )

    $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Type
    $ValueField = Get-InfobloxDNSRecordValueField -Type $NormalizedType
    if ($PSBoundParameters.ContainsKey('MatchValue') -and -not $ValueField) {
        throw "Value selection is not supported for record type '$($NormalizedType.ToUpperInvariant())'. Use ReferenceID."
    }

    $getRecordSplat = @{
        Name    = $Name
        Type    = $NormalizedType
        Verbose = $false
    }
    if ($View) {
        $getRecordSplat.View = $View
    }
    if ($PSBoundParameters.ContainsKey('MatchValue')) {
        $getRecordSplat.ReturnFields = @('name', 'view', $ValueField)
    }
    [Array] $Candidates = @(Get-InfobloxDNSRecord @getRecordSplat)
    $FallbackAcrossViews = $false
    if ($View -and $Candidates.Count -eq 0) {
        $getRecordSplat.Remove('View')
        [Array] $Candidates = @(Get-InfobloxDNSRecord @getRecordSplat)
        $FallbackAcrossViews = $true
    }
    [Array] $Selected = @($Candidates | Where-Object {
            $ViewMatches = -not $FallbackAcrossViews -or ($_.view -and ([string] $_.view) -ieq $View)
            $ValueMatches = -not $PSBoundParameters.ContainsKey('MatchValue') -or
                (Test-InfobloxDNSRecordValue -Type $NormalizedType -ActualValue $_.$ValueField -ExpectedValue $MatchValue)
            $ViewMatches -and $ValueMatches
        })
    [pscustomobject]@{
        Candidates = $Candidates
        Selected   = $Selected
        ValueField = $ValueField
    }
}
