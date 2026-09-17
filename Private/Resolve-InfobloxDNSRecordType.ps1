function Resolve-InfobloxDNSRecordType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Type
    )

    $NormalizedType = $Type.Trim().ToLowerInvariant()
    if ($NormalizedType -eq 'lbdn') {
        $NormalizedType = 'dtclbdn'
    }

    if ($NormalizedType -notmatch '^[a-z][a-z0-9_]*(?::[a-z][a-z0-9_]*)*$') {
        throw "Resolve-InfobloxDNSRecordType - DNS record type '$Type' is not a valid WAPI record type."
    }

    $NormalizedType
}
