function Format-InfobloxDNSManagedObjectCandidate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array] $Records,

        [Parameter(Mandatory)]
        [ValidateSet('view', 'zone_auth', 'zone_forward', 'zone_delegated', 'zone_rp', 'zone_stub')]
        [string] $ObjectType
    )

    if ($Records.Count -eq 0) {
        return '  No objects found.'
    }
    $Lines = @($Records | Select-Object -First 10 | ForEach-Object {
            $Identity = if ($ObjectType -eq 'view') { "name=$($_.name)" } else { "fqdn=$($_.fqdn); view=$($_.view)" }
            $Reference = if ($_._ref) { $_._ref } else { '<reference unavailable>' }
            $Details = if ($ObjectType -eq 'view') { "is_default=$($_.is_default); network_view=$($_.network_view)" } else { "disable=$($_.disable)" }
            "  $Reference ($Identity; $Details)"
        })
    if ($Records.Count -gt 10) {
        $Hint = if ($ObjectType -eq 'view') { 'Get-InfobloxDNSView' } else { 'Get-InfobloxObjects' }
        $Lines += "  ... and $($Records.Count - 10) more. Run $Hint to inspect every reference."
    }
    $Lines -join "`n"
}
