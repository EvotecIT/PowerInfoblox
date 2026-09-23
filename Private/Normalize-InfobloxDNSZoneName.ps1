function Normalize-InfobloxDNSZoneName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    if ($Name -eq '.') { return '.' }
    if ($Name.EndsWith('..', [System.StringComparison]::Ordinal)) {
        throw "DNS zone name '$Name' cannot have more than one trailing dot."
    }
    $Name.TrimEnd('.').ToLowerInvariant()
}
