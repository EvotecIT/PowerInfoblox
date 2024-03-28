function Convert-IpAddressToPtrString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$IPAddress
    )

    # Split the IP address into its octets
    $octets = $IPAddress -split "\."

    # Reverse the octets
    [array]::Reverse($octets)

    # Join the reversed octets with dots and append the standard PTR suffix
    $ptrString = ($octets -join ".") + ".in-addr.arpa"

    $ptrString
}