function Add-InfobloxFixedAddress {
    <#
    .SYNOPSIS
    Add a fixed mac address to an IP address on an Infoblox server

    .DESCRIPTION
    Add a fixed mac address to an IP address on an Infoblox server
    A fixed address is a specific IP address that a DHCP server always assigns when a lease request comes from
    a particular MAC address of the client. For example, if you have a printer in your network, you can reserve a
    particular IP address to be assigned to it every time it is turned on.

    .PARAMETER IPv4Address
    IPv4 address to add the mac address to

    .PARAMETER MacAddress
    Mac address to add to the IPv4 address

    .PARAMETER Name
    Name of the fixed address

    .PARAMETER Comment
    Comment for the fixed address

    .PARAMETER MicrosoftServer
    IPv4 address or FQDN of the Microsoft DHCP server to use for the fixed address.

    .EXAMPLE
    Add-InfobloxFixedAddress -IPv4Address '10.2.2.18' -MacAddress '00:50:56:9A:00:01'

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [ValidateNotNullOrEmpty()][parameter(Mandatory)][string] $IPv4Address,
        [ValidatePattern("([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")][parameter(Mandatory)][string] $MacAddress,
        [string] $Name,
        [string] $Comment,
        [alias('ms_server')][string] $MicrosoftServer
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfobloxFixedAddress - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Add-InfobloxFixedAddress - Adding IPv4Address $IPv4Address to MacAddress $MacAddress"

    $Body = [ordered] @{
        ipv4addr = $IPv4Address
        mac      = $MacAddress.ToLower()
    }
    if ($Name) {
        $Body['name'] = $Name
    }
    if ($Comment) {
        $Body['comment'] = $Comment
    }
    if ($MicrosoftServer) {
        $Body['ms_server'] = ConvertTo-InfobloxMicrosoftDHCPServer -MicrosoftServer $MicrosoftServer
    }
    $invokeInfobloxQuerySplat = @{
        RelativeUri = 'fixedaddress'
        Method      = 'POST'
        Body        = $Body
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat #-WarningAction SilentlyContinue -WarningVariable varWarning
    if ($Output) {
        Write-Verbose -Message "Add-InfobloxFixedAddress - Added $($Output.ipv4addr) with mac address $($Output.mac) / $Output"
    }
}
