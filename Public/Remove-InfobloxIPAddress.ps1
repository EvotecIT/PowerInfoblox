function Remove-InfobloxIPAddress {
    <#
    .SYNOPSIS
    Removes an IP address from Infoblox.

    .DESCRIPTION
    This function removes an IP address from Infoblox. It checks for an existing connection to an Infoblox server, established via Connect-Infoblox, before attempting the removal. The function supports verbose output for detailed operation insights.

    .PARAMETER IPv4Address
    The IPv4 address to be removed from Infoblox. This parameter is mandatory.

    .EXAMPLE
    Remove-InfobloxIPAddress -IPv4Address '192.168.1.100'
    Removes the IP address 192.168.1.100 from Infoblox.

    .NOTES
    Ensure you are connected to an Infoblox server using Connect-Infoblox before executing this function. The function uses Write-Verbose for detailed operation output, which can be enabled by setting $VerbosePreference or using the -Verbose switch.
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [parameter()][string] $IPv4Address
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Remove-InfobloxIPAddress - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Remove-InfobloxIPAddress - Removing $IPv4Address"

    $ListIP = Get-InfobloxIPAddress -IPv4Address $IPv4Address
    foreach ($IP in $ListIP) {
        $invokeInfobloxQuerySplat = @{
            RelativeUri = "$($IP._ref)"
            Method      = 'DELETE'
        }
        $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
        if ($Output) {
            Write-Verbose -Message "Remove-InfobloxIPAddress - Removed $($IP.ip_address) from network $($IP.network) / $Output"
        }
    }
}