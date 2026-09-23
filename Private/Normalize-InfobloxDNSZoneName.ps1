function Normalize-InfobloxDNSZoneName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    if ($Name -eq '.') { return '.' }
    $Name.TrimEnd('.')
}
