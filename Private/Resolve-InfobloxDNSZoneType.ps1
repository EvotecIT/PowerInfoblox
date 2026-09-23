function Resolve-InfobloxDNSZoneType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Authoritative', 'Forward', 'Delegated')]
        [string] $Type
    )

    switch ($Type) {
        'Authoritative' { 'zone_auth' }
        'Forward' { 'zone_forward' }
        'Delegated' { 'zone_delegated' }
    }
}
