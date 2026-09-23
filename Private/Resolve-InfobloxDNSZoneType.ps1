function Resolve-InfobloxDNSZoneType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Authoritative', 'Forward', 'Delegated', 'ResponsePolicy', 'Stub')]
        [string] $Type
    )

    switch ($Type) {
        'Authoritative' { 'zone_auth' }
        'Forward' { 'zone_forward' }
        'Delegated' { 'zone_delegated' }
        'ResponsePolicy' { 'zone_rp' }
        'Stub' { 'zone_stub' }
    }
}
