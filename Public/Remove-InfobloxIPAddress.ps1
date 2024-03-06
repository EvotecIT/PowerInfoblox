function Remove-InfobloxIPAddress {
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
        $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WarningAction SilentlyContinue -WarningVariable varWarning
        if ($Output) {
            Write-Verbose -Message "Remove-InfobloxIPAddress - Removed $($IP.ip_address) from network $($IP.network) / $Output"
        } else {
            if (-not $WhatIfPreference) {
                Write-Warning -Message "Remove-InfobloxIPAddress - Failed to remove $($IP.ip_address) with mac address $($IP.network), error: $varWarning"
            }
        }
    }
}