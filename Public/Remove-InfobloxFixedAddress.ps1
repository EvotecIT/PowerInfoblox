function Remove-InfobloxFixedAddress {
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory)][string] $MacAddress,
        [parameter()][string] $IPv4Address
    )

    if (-not $Script:InfobloxConfiguration) {
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
        $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WarningAction SilentlyContinue -WarningVariable varWarning
        if ($Output) {
            Write-Verbose -Message "Remove-InfobloxFixedAddress - Removed $($Mac.ipv4addr) with mac address $($Mac.mac) / $Output"
        } else {
            Write-Warning -Message "Remove-InfobloxFixedAddress - Failed to remove $($Mac.ipv4addr) with mac address $($Mac.mac), error: $varWarning"
        }
    }
}