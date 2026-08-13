function Add-InfobloxDHCPReservation {
    <#
    .SYNOPSIS
    Add a DHCP reservation to an Infoblox server

    .DESCRIPTION
    Add a DHCP reservation to an Infoblox server

    .PARAMETER IPv4Address
    IPv4 address to add the mac address to

    .PARAMETER MacAddress
    Mac address to add to the IPv4 address

    .PARAMETER Name
    Name of the fixed address

    .PARAMETER Comment
    Comment for the fixed address

    .PARAMETER Network
    Subnet to add the reservation to

    .PARAMETER MicrosoftServer
    IPv4 address or FQDN of the Microsoft DHCP server to use for the reservation.

    .EXAMPLE
    Add-InfobloxDHCPReservation -IPv4Address '10.2.2.18' -MacAddress '00:50:56:9A:00:01' -Name 'MyReservation' -Network '10.2.2.0/24' -Comment 'This is a test reservation' -MicrosoftServer 'myserver'

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [ValidateNotNullOrEmpty()][parameter(Mandatory)][string] $IPv4Address,
        [ValidatePattern("([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")][parameter(Mandatory)][string] $MacAddress,
        [ValidateNotNullOrEmpty()][parameter(Mandatory)][string] $Name,
        [ValidateNotNullOrEmpty()][parameter(Mandatory)][string] $Network,
        [string] $Comment,
        [alias('ms_server')][string] $MicrosoftServer
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfobloxDHCPReservation - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $Body = [ordered] @{
        ipv4addr = $IPv4Address
        mac      = $MacAddress.ToLower()
        network  = $Network
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
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Add-InfobloxDHCPReservation - Added $($Output.ipv4addr) with mac address $($Output.mac) / $Output"
    }
}
