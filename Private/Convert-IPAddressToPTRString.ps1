function Convert-IpAddressToPtrString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$IPAddress
    )

    $ParsedAddress = $null
    if (-not [System.Net.IPAddress]::TryParse($IPAddress, [ref] $ParsedAddress)) {
        throw "Convert-IpAddressToPtrString - '$IPAddress' is not a valid IPv4 or IPv6 address."
    }

    if ($ParsedAddress.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork) {
        $Octets = $ParsedAddress.GetAddressBytes()
        [array]::Reverse($Octets)
        return (($Octets -join '.') + '.in-addr.arpa')
    }

    $HexAddress = -join ($ParsedAddress.GetAddressBytes() | ForEach-Object { $_.ToString('x2') })
    $Nibbles = $HexAddress.ToCharArray()
    [array]::Reverse($Nibbles)
    ($Nibbles -join '.') + '.ip6.arpa'
}
