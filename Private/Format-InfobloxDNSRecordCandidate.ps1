function Format-InfobloxDNSRecordCandidate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array] $Records,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Type,

        [string] $ValueField
    )

    $Lines = @($Records | Select-Object -First 10 | ForEach-Object {
            $CandidateValue = if ($ValueField -and $null -ne $_.$ValueField) { "$ValueField=$($_.$ValueField)" } else { 'value unavailable' }
            $CandidateView = if ($_.view) { "view=$($_.view)" } else { 'view unavailable' }
            "  $($_._ref) ($CandidateView; $CandidateValue)"
        })
    if ($Records.Count -gt 10) {
        $Lines += "  ... and $($Records.Count - 10) more. Run Get-InfobloxDNSRecord -Type $Type -Name '$Name' to inspect every reference."
    }
    $Lines -join "`n"
}
