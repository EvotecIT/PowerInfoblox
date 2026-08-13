function ConvertTo-InfobloxMicrosoftDHCPServer {
    <#
    .SYNOPSIS
    Converts a Microsoft DHCP server address to the WAPI msdhcpserver structure.

    .PARAMETER MicrosoftServer
    IPv4 address or FQDN of a Microsoft DHCP server known to Infoblox.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $MicrosoftServer
    )

    [pscustomobject] @{
        _struct  = 'msdhcpserver'
        ipv4addr = $MicrosoftServer
    }
}
