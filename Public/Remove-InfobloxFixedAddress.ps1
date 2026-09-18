function Remove-InfobloxFixedAddress {
    <#
    .SYNOPSIS
    Removes fixed IPv4 address assignments by MAC address.

    .DESCRIPTION
    Finds fixedaddress objects using an exact MAC address match and removes each
    matching object. Specify IPv4Address to narrow removal to one address. The
    command supports WhatIf and Confirm.

    .PARAMETER MacAddress
    Specifies the exact MAC address whose fixed assignments should be removed.

    .PARAMETER IPv4Address
    Limits removal to a fixed assignment with this IPv4 address.

    .EXAMPLE
    Remove-InfobloxFixedAddress -MacAddress '00:11:22:33:44:55' -IPv4Address '192.0.2.15' -WhatIf

    Shows the fixed address assignment targeted by the command without requesting removal.

    .EXAMPLE
    Remove-InfobloxFixedAddress -MacAddress '00:11:22:33:44:55' -Confirm

    Requests confirmation while removing all fixed assignments for the exact MAC address.
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory)][string] $MacAddress,
        [parameter()][string] $IPv4Address
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Remove-InfobloxFixedAddress - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if (-not $IPv4Address) {
        Write-Verbose -Message "Remove-InfobloxFixedAddress - Removing $MacAddress"
    } else {
        Write-Verbose -Message "Remove-InfobloxFixedAddress - Removing $MacAddress from $IPv4Address"
    }

    $ListMacaddresses = Get-InfobloxFixedAddress -MacAddress $MacAddress

    if ($IPv4Address) {
        $ListMacaddresses = $ListMacaddresses | Where-Object -Property ipv4addr -EQ -Value $IPv4Address
    }
    foreach ($Mac in $ListMacaddresses) {
        $invokeInfobloxQuerySplat = @{
            RelativeUri = "$($Mac._ref)"
            Method      = 'DELETE'
        }
        $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat #-WarningAction SilentlyContinue -WarningVariable varWarning
        if ($Output) {
            Write-Verbose -Message "Remove-InfobloxFixedAddress - Removed $($Mac.ipv4addr) with mac address $($Mac.mac) / $Output"
        }
        #else {
        #if (-not $WhatIfPreference) {
        # Write-Warning -Message "Remove-InfobloxFixedAddress - Failed to remove $($Mac.ipv4addr) with mac address $($Mac.mac), error: $varWarning"
        #}
        #}
    }
}
